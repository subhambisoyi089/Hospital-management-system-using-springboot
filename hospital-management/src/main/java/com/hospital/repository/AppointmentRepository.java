package com.hospital.repository;

import com.hospital.entity.Appointment;
import com.hospital.entity.Appointment.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByStatus(Status status);
    List<Appointment> findByAppointmentDate(LocalDate date);
    List<Appointment> findByDoctorId(Long doctorId);
    List<Appointment> findByPatientId(Long patientId);
    List<Appointment> findByAppointmentDateAndDoctorId(LocalDate date, Long doctorId);
    List<Appointment> findAllByOrderByAppointmentDateDescAppointmentTimeDesc();

    @Query("SELECT COUNT(a) FROM Appointment a WHERE a.status = 'SCHEDULED'")
    long countScheduled();

    @Query("SELECT COUNT(a) FROM Appointment a WHERE a.appointmentDate = :today")
    long countTodayAppointments(LocalDate today);

    List<Appointment> findByAppointmentDateBetween(LocalDate from, LocalDate to);
}
