package com.hospital.service;

import com.hospital.entity.Appointment;
import com.hospital.entity.Appointment.Status;
import com.hospital.entity.Doctor;
import com.hospital.entity.Patient;
import com.hospital.repository.AppointmentRepository;
import com.hospital.repository.DoctorRepository;
import com.hospital.repository.PatientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class AppointmentService {

    private final AppointmentRepository appointmentRepository;
    private final DoctorRepository doctorRepository;
    private final PatientRepository patientRepository;

    public List<Appointment> findAll() {
        return appointmentRepository.findAllByOrderByAppointmentDateDescAppointmentTimeDesc();
    }

    public Optional<Appointment> findById(Long id) {
        return appointmentRepository.findById(id);
    }

    public Appointment book(Long patientId, Long doctorId, Appointment appointment, String bookedBy) {
        Patient patient = patientRepository.findById(patientId)
            .orElseThrow(() -> new RuntimeException("Patient not found"));
        Doctor doctor = doctorRepository.findById(doctorId)
            .orElseThrow(() -> new RuntimeException("Doctor not found"));

        appointment.setPatient(patient);
        appointment.setDoctor(doctor);
        appointment.setBookedBy(bookedBy);
        appointment.setStatus(Status.SCHEDULED);
        appointment.setTokenNumber(generateToken(doctorId, appointment.getAppointmentDate()));
        return appointmentRepository.save(appointment);
    }

    public void updateStatus(Long id, Status status) {
        Appointment a = appointmentRepository.findById(id).orElseThrow();
        a.setStatus(status);
        appointmentRepository.save(a);
    }

    public void delete(Long id) { appointmentRepository.deleteById(id); }

    public List<Appointment> findByDate(LocalDate date) {
        return appointmentRepository.findByAppointmentDate(date);
    }

    public List<Appointment> findToday() {
        return appointmentRepository.findByAppointmentDate(LocalDate.now());
    }

    public List<Appointment> findByDoctor(Long doctorId) {
        return appointmentRepository.findByDoctorId(doctorId);
    }

    public List<Appointment> findByPatient(Long patientId) {
        return appointmentRepository.findByPatientId(patientId);
    }

    public long countScheduled() { return appointmentRepository.countScheduled(); }
    public long countToday() { return appointmentRepository.countTodayAppointments(LocalDate.now()); }
    public long countTotal() { return appointmentRepository.count(); }

    private String generateToken(Long doctorId, LocalDate date) {
        long count = appointmentRepository.findByAppointmentDateAndDoctorId(date, doctorId).size();
        return "T-" + String.format("%03d", count + 1);
    }
}
