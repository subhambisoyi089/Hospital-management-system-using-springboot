package com.hospital.service;

import com.hospital.entity.Doctor;
import com.hospital.repository.DoctorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class DoctorService {

    private final DoctorRepository doctorRepository;

    public List<Doctor> findAll() { return doctorRepository.findAll(); }
    public Optional<Doctor> findById(Long id) { return doctorRepository.findById(id); }
    public List<Doctor> findAvailable() { return doctorRepository.findByAvailableTrue(); }

    public Doctor save(Doctor doctor) {
        if (doctor.getId() == null && doctorRepository.existsByEmail(doctor.getEmail())) {
            throw new IllegalArgumentException("Email already registered.");
        }
        return doctorRepository.save(doctor);
    }

    public void deleteById(Long id) { doctorRepository.deleteById(id); }

    public List<Doctor> search(String query) {
        return doctorRepository.findByFullNameContainingIgnoreCase(query);
    }

    public void toggleAvailability(Long id) {
        Doctor d = doctorRepository.findById(id).orElseThrow();
        d.setAvailable(!d.isAvailable());
        doctorRepository.save(d);
    }

    public long countTotal() { return doctorRepository.count(); }
    public long countAvailable() { return doctorRepository.findByAvailableTrue().size(); }
}
