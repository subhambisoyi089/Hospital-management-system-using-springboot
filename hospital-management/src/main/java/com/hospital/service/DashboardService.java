package com.hospital.service;

import com.hospital.entity.Appointment;
import com.hospital.entity.AppointmentStatus;
import com.hospital.repository.AppointmentRepository;
import com.hospital.repository.DoctorRepository;
import com.hospital.repository.PatientRepository;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DashboardService {

    private final AppointmentRepository appointments;
    private final DoctorRepository doctors;
    private final PatientRepository patients;

    public DashboardService(AppointmentRepository appointments, DoctorRepository doctors,
                            PatientRepository patients) {
        this.appointments = appointments;
        this.doctors = doctors;
        this.patients = patients;
    }

    @Transactional(readOnly = true)
    public DashboardData build() {
        LocalDate today = LocalDate.now();
        List<Appointment> todays = appointments.findByAppointmentDateOrderByAppointmentTimeAsc(today);

        Map<Long, DashboardData.DoctorQueue> byDoctor = new LinkedHashMap<>();
        for (Appointment a : todays) {
            byDoctor.computeIfAbsent(a.getDoctor().getId(), id -> new DashboardData.DoctorQueue(a.getDoctor())).add(a);
        }
        List<DashboardData.DoctorQueue> queues = new ArrayList<>(byDoctor.values());
        queues.sort(Comparator.comparing(q -> q.getDoctor().getFullName()));

        long waiting = todays.stream().filter(a -> a.getStatus() == AppointmentStatus.SCHEDULED).count();
        long done = todays.stream().filter(a -> a.getStatus() == AppointmentStatus.COMPLETED).count();
        long upcoming = appointments.countByStatusAndAppointmentDateGreaterThan(AppointmentStatus.SCHEDULED, today);

        return new DashboardData(patients.count(), doctors.count(), doctors.countByAvailableTrue(),
                todays.size(), waiting, done, upcoming, queues);
    }
}
