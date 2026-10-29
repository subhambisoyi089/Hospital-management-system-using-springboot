package com.hospital.service;

import com.hospital.entity.Patient;
import com.hospital.exception.BusinessException;
import com.hospital.repository.AppointmentRepository;
import com.hospital.repository.PatientRepository;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PatientService {

    private static final List<String> BLOOD_GROUPS = List.of("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-");

    private final PatientRepository patients;
    private final AppointmentRepository appointments;

    public PatientService(PatientRepository patients, AppointmentRepository appointments) {
        this.patients = patients;
        this.appointments = appointments;
    }

    @Transactional(readOnly = true)
    public List<Patient> search(String q) {
        if (q == null || q.isBlank()) {
            return patients.findAllByOrderByIdDesc();
        }
        return patients.search(q.trim());
    }

    @Transactional(readOnly = true)
    public List<Patient> findAll() {
        return patients.findAllByOrderByIdDesc();
    }

    @Transactional(readOnly = true)
    public Patient get(Long id) {
        return patients.findById(id).orElseThrow(() -> new BusinessException("That patient was not found."));
    }

    /** Adds a patient (form id == null) or updates one. Only the editable fields are copied from the form. */
    @Transactional
    public Patient save(Patient form) {
        String name = Validation.required(form.getFullName(), "Enter the patient's name.");
        String phone = Validation.phone(form.getPhone());
        String email = Validation.email(form.getEmail(), false);
        if (form.getDateOfBirth() != null && form.getDateOfBirth().isAfter(LocalDate.now())) {
            throw new BusinessException("The date of birth can't be in the future.");
        }
        String blood = Validation.clean(form.getBloodGroup());
        if (blood != null && !BLOOD_GROUPS.contains(blood)) {
            throw new BusinessException("Choose a valid blood group.");
        }

        boolean isNew = form.getId() == null;
        Patient patient;
        if (isNew) {
            patient = new Patient();
            patient.setPatientId("TMP-" + UUID.randomUUID().toString().substring(0, 8));
            patient.setRegisteredOn(LocalDate.now());
        } else {
            patient = get(form.getId());
        }
        patient.setFullName(name);
        patient.setPhone(phone);
        patient.setEmail(email);
        patient.setDateOfBirth(form.getDateOfBirth());
        patient.setGender(Validation.clean(form.getGender()));
        patient.setAddress(Validation.clean(form.getAddress()));
        patient.setBloodGroup(blood);
        patient.setMedicalHistory(Validation.clean(form.getMedicalHistory()));

        patient = patients.save(patient);
        if (isNew) {
            // The id is known now, so the patient number can never repeat.
            patient.setPatientId(String.format("PAT-%05d", 10000 + patient.getId()));
            patient = patients.save(patient);
        }
        return patient;
    }

    @Transactional
    public void delete(Long id) {
        Patient patient = get(id);
        if (appointments.countByPatientId(id) > 0) {
            throw new BusinessException(patient.getFullName() + " has appointments on record, so they can't be deleted.");
        }
        patients.delete(patient);
    }
}
