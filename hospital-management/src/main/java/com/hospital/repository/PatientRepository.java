package com.hospital.repository;

import com.hospital.entity.Patient;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PatientRepository extends JpaRepository<Patient, Long> {

    List<Patient> findAllByOrderByIdDesc();

    /** Matches part of the name, phone number or patient id. */
    @Query("""
            select p from Patient p
            where lower(p.fullName) like lower(concat('%', :q, '%'))
               or p.phone like concat('%', :q, '%')
               or lower(p.patientId) like lower(concat('%', :q, '%'))
            order by p.fullName
            """)
    List<Patient> search(@Param("q") String q);
}
