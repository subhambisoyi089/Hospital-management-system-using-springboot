package com.hospital.service;

import com.hospital.entity.Doctor;
import com.hospital.exception.BusinessException;
import com.hospital.repository.AppointmentRepository;
import com.hospital.repository.DoctorRepository;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DoctorService {

    private final DoctorRepository doctors;
    private final AppointmentRepository appointments;

    public DoctorService(DoctorRepository doctors, AppointmentRepository appointments) {
        this.doctors = doctors;
        this.appointments = appointments;
    }

    @Transactional(readOnly = true)
    public List<Doctor> search(String q) {
        if (q == null || q.isBlank()) {
            return doctors.findAllByOrderByFullNameAsc();
        }
        String term = q.trim();
        return doctors.findByFullNameContainingIgnoreCaseOrSpecializationContainingIgnoreCaseOrderByFullNameAsc(term, term);
    }

    @Transactional(readOnly = true)
    public List<Doctor> findAll() {
        return doctors.findAllByOrderByFullNameAsc();
    }

    @Transactional(readOnly = true)
    public List<Doctor> findAvailable() {
        return doctors.findByAvailableTrueOrderByFullNameAsc();
    }

    @Transactional(readOnly = true)
    public Doctor get(Long id) {
        return doctors.findById(id).orElseThrow(() -> new BusinessException("That doctor was not found."));
    }

    @Transactional
    public Doctor save(Doctor form) {
        String name = Validation.required(form.getFullName(), "Enter the doctor's name.");
        String specialization = Validation.required(form.getSpecialization(), "Enter the specialization.");
        String email = Validation.email(form.getEmail(), true);
        String phone = Validation.phone(form.getPhone());

        Integer experience = form.getExperienceYears();
        if (experience != null && (experience < 0 || experience > 70)) {
            throw new BusinessException("Experience must be between 0 and 70 years.");
        }
        BigDecimal fee = form.getConsultFee() == null ? BigDecimal.ZERO : form.getConsultFee();
        if (fee.signum() < 0) {
            throw new BusinessException("The consultation fee can't be negative.");
        }

        Doctor doctor;
        if (form.getId() == null) {
            if (doctors.existsByEmail(email)) {
                throw new BusinessException("A doctor with this email already exists.");
            }
            doctor = new Doctor();
        } else {
            doctor = get(form.getId());
            if (doctors.existsByEmailAndIdNot(email, doctor.getId())) {
                throw new BusinessException("Another doctor already uses this email.");
            }
        }
        doctor.setFullName(name);
        doctor.setSpecialization(specialization);
        doctor.setEmail(email);
        doctor.setPhone(phone);
        doctor.setQualification(Validation.clean(form.getQualification()));
        doctor.setExperienceYears(experience);
        doctor.setGender(Validation.clean(form.getGender()));
        doctor.setConsultFee(fee.setScale(2, RoundingMode.HALF_UP));
        doctor.setAvailable(form.isAvailable());
        return doctors.save(doctor);
    }

    @Transactional
    public void toggleAvailability(Long id) {
        Doctor doctor = get(id);
        doctor.setAvailable(!doctor.isAvailable());
        doctors.save(doctor);
    }

    @Transactional
    public void delete(Long id) {
        Doctor doctor = get(id);
        if (appointments.countByDoctorId(id) > 0) {
            throw new BusinessException(doctor.getFullName()
                    + " has appointments on record, so they can't be deleted. Mark the doctor unavailable instead.");
        }
        doctors.delete(doctor);
    }
}
