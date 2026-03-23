package com.hospital.service;

import com.hospital.entity.Patient;
import com.hospital.repository.PatientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class PatientService {

    private final PatientRepository patientRepository;

    public List<Patient> findAll() { return patientRepository.findAll(); }
    public Optional<Patient> findById(Long id) { return patientRepository.findById(id); }

    public Patient save(Patient patient) {
        if (patient.getId() == null) {
            patient.setPatientId(generatePatientId());
        }
        return patientRepository.save(patient);
    }

    public void deleteById(Long id) { patientRepository.deleteById(id); }

    public List<Patient> search(String name) {
        return patientRepository.findByFullNameContainingIgnoreCase(name);
    }

    public long countTotal() { return patientRepository.count(); }

    private String generatePatientId() {
        return "PAT-" + System.currentTimeMillis() % 100000;
    }
}
