package com.hospital.service;

import com.hospital.entity.Appointment;
import com.hospital.entity.AppointmentStatus;
import com.hospital.entity.Doctor;
import com.hospital.entity.Patient;
import com.hospital.exception.BusinessException;
import com.hospital.repository.AppointmentRepository;
import com.hospital.repository.DoctorRepository;
import com.hospital.repository.PatientRepository;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AppointmentService {

    private static final DateTimeFormatter TIME_TEXT = DateTimeFormatter.ofPattern("hh:mm a", Locale.ENGLISH);

    private final AppointmentRepository appointments;
    private final DoctorRepository doctors;
    private final PatientRepository patients;

    public AppointmentService(AppointmentRepository appointments, DoctorRepository doctors,
                              PatientRepository patients) {
        this.appointments = appointments;
        this.doctors = doctors;
        this.patients = patients;
    }

    /** All appointments, newest first, narrowed by any filter that isn't null. */
    @Transactional(readOnly = true)
    public List<Appointment> list(LocalDate date, AppointmentStatus status, Long doctorId) {
        return appointments.findAllByOrderByAppointmentDateDescAppointmentTimeDesc().stream()
                .filter(a -> date == null || a.getAppointmentDate().equals(date))
                .filter(a -> status == null || a.getStatus() == status)
                .filter(a -> doctorId == null || a.getDoctor().getId().equals(doctorId))
                .toList();
    }

    @Transactional(readOnly = true)
    public Appointment get(Long id) {
        return appointments.findById(id).orElseThrow(() -> new BusinessException("That appointment was not found."));
    }

    @Transactional(readOnly = true)
    public List<Appointment> forPatient(Long patientId) {
        return appointments.findByPatientIdOrderByAppointmentDateDescAppointmentTimeDesc(patientId);
    }

    @Transactional(readOnly = true)
    public List<Appointment> forDoctor(Long doctorId) {
        return appointments.findByDoctorIdOrderByAppointmentDateDescAppointmentTimeDesc(doctorId);
    }

    /** Times (HH:mm) this doctor already has a scheduled appointment on that day. */
    @Transactional(readOnly = true)
    public List<String> bookedTimes(Long doctorId, LocalDate date) {
        return appointments.findByDoctorIdAndAppointmentDateOrderByAppointmentTimeAsc(doctorId, date).stream()
                .filter(Appointment::isScheduled)
                .map(a -> a.getAppointmentTime().toString())
                .toList();
    }

    @Transactional
    public Appointment book(Long patientId, Long doctorId, LocalDate date, LocalTime time,
                            String symptoms, String notes, String bookedBy) {
        if (patientId == null) {
            throw new BusinessException("Choose a patient.");
        }
        if (doctorId == null) {
            throw new BusinessException("Choose a doctor.");
        }
        if (date == null || time == null) {
            throw new BusinessException("Choose the appointment date and time.");
        }
        time = time.withSecond(0).withNano(0);

        Patient patient = patients.findById(patientId)
                .orElseThrow(() -> new BusinessException("That patient was not found."));
        Doctor doctor = doctors.findById(doctorId)
                .orElseThrow(() -> new BusinessException("That doctor was not found."));
        if (!doctor.isAvailable()) {
            throw new BusinessException(doctor.getFullName() + " is not available right now. Choose another doctor.");
        }

        LocalDate today = LocalDate.now();
        if (date.isBefore(today) || (date.equals(today) && time.isBefore(LocalTime.now()))) {
            throw new BusinessException("The appointment time can't be in the past.");
        }
        if (appointments.existsByDoctorIdAndAppointmentDateAndAppointmentTimeAndStatus(
                doctorId, date, time, AppointmentStatus.SCHEDULED)) {
            throw new BusinessException(doctor.getFullName() + " already has an appointment at "
                    + time.format(TIME_TEXT) + " on that day. Pick another time.");
        }
        if (appointments.existsByPatientIdAndAppointmentDateAndAppointmentTimeAndStatus(
                patientId, date, time, AppointmentStatus.SCHEDULED)) {
            throw new BusinessException(patient.getFullName() + " already has an appointment at "
                    + time.format(TIME_TEXT) + " on that day.");
        }

        Appointment appointment = new Appointment();
        appointment.setPatient(patient);
        appointment.setDoctor(doctor);
        appointment.setAppointmentDate(date);
        appointment.setAppointmentTime(time);
        appointment.setSymptoms(Validation.clean(symptoms));
        appointment.setNotes(Validation.clean(notes));
        appointment.setBookedBy(bookedBy);
        Integer lastToken = appointments.maxToken(doctorId, date);
        appointment.setTokenNo(lastToken == null ? 1 : lastToken + 1);
        return appointments.save(appointment);
    }

    /** A scheduled appointment can be completed, cancelled or marked no-show. Those are final. */
    @Transactional
    public Appointment changeStatus(Long id, AppointmentStatus newStatus) {
        Appointment appointment = get(id);
        if (newStatus == null || newStatus == AppointmentStatus.SCHEDULED) {
            throw new BusinessException("Choose Completed, Cancelled or No show.");
        }
        if (!appointment.isScheduled()) {
            throw new BusinessException("This appointment is already " + appointment.getStatus().getLabel().toLowerCase() + ".");
        }
        appointment.setStatus(newStatus);
        return appointments.save(appointment);
    }

    @Transactional
    public void delete(Long id) {
        appointments.delete(get(id));
    }
}
