package com.hospital.config;

import com.hospital.entity.*;
import com.hospital.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final RoleRepository roleRepository;
    private final UserRepository userRepository;
    private final DoctorRepository doctorRepository;
    private final PatientRepository patientRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public void run(String... args) {
        log.info("Seeding data...");

        // Roles
        Role adminRole = getOrCreate("ROLE_ADMIN", "Administrator");
        Role recRole   = getOrCreate("ROLE_RECEPTIONIST", "Receptionist");

        // Users
        if (!userRepository.existsByUsername("admin")) {
            userRepository.save(User.builder()
                .username("admin").password(passwordEncoder.encode("admin123"))
                .fullName("Admin User").email("admin@hospital.com").phone("9000000001")
                .enabled(true).roles(new HashSet<>(Set.of(adminRole))).build());
        }
        if (!userRepository.existsByUsername("receptionist")) {
            userRepository.save(User.builder()
                .username("receptionist").password(passwordEncoder.encode("rec123"))
                .fullName("Mary Receptionist").email("rec@hospital.com").phone("9000000002")
                .enabled(true).roles(new HashSet<>(Set.of(recRole))).build());
        }

        // Doctors
        if (doctorRepository.count() == 0) {
            doctorRepository.saveAll(List.of(
                Doctor.builder().fullName("Dr. Arjun Sharma").specialization("Cardiology")
                    .email("arjun@hospital.com").phone("9100000001").qualification("MD")
                    .experienceYears(12).gender("Male").consultFee(500.0).available(true).build(),
                Doctor.builder().fullName("Dr. Priya Patel").specialization("Neurology")
                    .email("priya@hospital.com").phone("9100000002").qualification("DM")
                    .experienceYears(8).gender("Female").consultFee(600.0).available(true).build(),
                Doctor.builder().fullName("Dr. Rahul Mehta").specialization("Orthopedics")
                    .email("rahul@hospital.com").phone("9100000003").qualification("MS")
                    .experienceYears(15).gender("Male").consultFee(450.0).available(true).build(),
                Doctor.builder().fullName("Dr. Sunita Rao").specialization("Pediatrics")
                    .email("sunita@hospital.com").phone("9100000004").qualification("MD")
                    .experienceYears(10).gender("Female").consultFee(400.0).available(true).build(),
                Doctor.builder().fullName("Dr. Vikram Singh").specialization("Dermatology")
                    .email("vikram@hospital.com").phone("9100000005").qualification("MD")
                    .experienceYears(7).gender("Male").consultFee(350.0).available(false).build()
            ));
        }

        // Patients
        if (patientRepository.count() == 0) {
            patientRepository.saveAll(List.of(
                Patient.builder().fullName("Ravi Kumar").patientId("PAT-10001")
                    .phone("9200000001").email("ravi@email.com").gender("Male")
                    .dateOfBirth(LocalDate.of(1985, 4, 12)).bloodGroup("O+")
                    .address("12 MG Road, Bhubaneswar").registeredOn(LocalDate.now()).build(),
                Patient.builder().fullName("Sneha Nair").patientId("PAT-10002")
                    .phone("9200000002").email("sneha@email.com").gender("Female")
                    .dateOfBirth(LocalDate.of(1992, 8, 25)).bloodGroup("B+")
                    .address("45 Park Street, Bhubaneswar").registeredOn(LocalDate.now()).build(),
                Patient.builder().fullName("Mohan Das").patientId("PAT-10003")
                    .phone("9200000003").email("mohan@email.com").gender("Male")
                    .dateOfBirth(LocalDate.of(1970, 1, 3)).bloodGroup("A-")
                    .address("77 Station Road, Bhubaneswar").registeredOn(LocalDate.now()).build()
            ));
        }

        log.info("=== CREDENTIALS ===");
        log.info("Admin        -> admin / admin123");
        log.info("Receptionist -> receptionist / rec123");
    }

    private Role getOrCreate(String name, String desc) {
        return roleRepository.findByName(name).orElseGet(() ->
            roleRepository.save(Role.builder().name(name).description(desc).build()));
    }
}
