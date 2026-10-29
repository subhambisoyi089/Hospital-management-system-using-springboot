package com.hospital.repository;

import com.hospital.entity.Appointment;
import com.hospital.entity.AppointmentStatus;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {

    List<Appointment> findAllByOrderByAppointmentDateDescAppointmentTimeDesc();

    List<Appointment> findByAppointmentDateOrderByAppointmentTimeAsc(LocalDate date);

    List<Appointment> findByDoctorIdAndAppointmentDateOrderByAppointmentTimeAsc(Long doctorId, LocalDate date);

    List<Appointment> findByDoctorIdOrderByAppointmentDateDescAppointmentTimeDesc(Long doctorId);

    List<Appointment> findByPatientIdOrderByAppointmentDateDescAppointmentTimeDesc(Long patientId);

    boolean existsByDoctorIdAndAppointmentDateAndAppointmentTimeAndStatus(
            Long doctorId, LocalDate date, LocalTime time, AppointmentStatus status);

    boolean existsByPatientIdAndAppointmentDateAndAppointmentTimeAndStatus(
            Long patientId, LocalDate date, LocalTime time, AppointmentStatus status);

    long countByDoctorId(Long doctorId);

    long countByPatientId(Long patientId);

    long countByStatusAndAppointmentDateGreaterThan(AppointmentStatus status, LocalDate date);

    /** Highest token already given to this doctor on this day (null when none). */
    @Query("select max(a.tokenNo) from Appointment a where a.doctor.id = :doctorId and a.appointmentDate = :date")
    Integer maxToken(@Param("doctorId") Long doctorId, @Param("date") LocalDate date);
}
