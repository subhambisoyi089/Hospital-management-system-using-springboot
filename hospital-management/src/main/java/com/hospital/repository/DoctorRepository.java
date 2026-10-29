package com.hospital.repository;

import com.hospital.entity.Doctor;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DoctorRepository extends JpaRepository<Doctor, Long> {

    List<Doctor> findAllByOrderByFullNameAsc();

    List<Doctor> findByAvailableTrueOrderByFullNameAsc();

    List<Doctor> findByFullNameContainingIgnoreCaseOrSpecializationContainingIgnoreCaseOrderByFullNameAsc(
            String name, String specialization);

    long countByAvailableTrue();

    boolean existsByEmail(String email);

    boolean existsByEmailAndIdNot(String email, Long id);
}
