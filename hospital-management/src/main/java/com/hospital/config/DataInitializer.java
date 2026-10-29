package com.hospital.config;

import com.hospital.entity.Appointment;
import com.hospital.entity.AppointmentStatus;
import com.hospital.entity.Doctor;
import com.hospital.entity.Patient;
import com.hospital.entity.Role;
import com.hospital.entity.User;
import com.hospital.repository.AppointmentRepository;
import com.hospital.repository.DoctorRepository;
import com.hospital.repository.PatientRepository;
import com.hospital.repository.RoleRepository;
import com.hospital.repository.UserRepository;
import com.hospital.service.DoctorService;
import com.hospital.service.PatientService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/** On first run, creates the roles, two logins and some sample doctors, patients and today's queue. */
@Component
public class DataInitializer implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);

    private final RoleRepository roles;
    private final UserRepository users;
    private final DoctorRepository doctors;
    private final PatientRepository patients;
    private final AppointmentRepository appointments;
    private final DoctorService doctorService;
    private final PatientService patientService;
    private final PasswordEncoder encoder;
    private final String adminPassword;
    private final String receptionistPassword;

    public DataInitializer(RoleRepository roles, UserRepository users, DoctorRepository doctors,
                           PatientRepository patients, AppointmentRepository appointments,
                           DoctorService doctorService, PatientService patientService,
                           PasswordEncoder encoder,
                           @Value("${app.admin.password}") String adminPassword,
                           @Value("${app.receptionist.password}") String receptionistPassword) {
        this.roles = roles;
        this.users = users;
        this.doctors = doctors;
        this.patients = patients;
        this.appointments = appointments;
        this.doctorService = doctorService;
        this.patientService = patientService;
        this.encoder = encoder;
        this.adminPassword = adminPassword;
        this.receptionistPassword = receptionistPassword;
    }

    @Override
    @Transactional
    public void run(String... args) {
        Role adminRole = role("ROLE_ADMIN", "Administrator");
        Role receptionRole = role("ROLE_RECEPTIONIST", "Receptionist");

        if (!users.existsByUsername("admin")) {
            users.save(user("admin", adminPassword, "Hospital Admin", "admin@hospital.local", "9000000001", adminRole));
        }
        if (!users.existsByUsername("receptionist")) {
            users.save(user("receptionist", receptionistPassword, "Front Desk", "frontdesk@hospital.local",
                    "9000000002", receptionRole));
        }

        if (doctors.count() == 0) {
            addDoctor("Dr. Arjun Sharma", "Cardiology", "arjun@hospital.local", "9100000001", "MD", 12, "Male", "500", true);
            addDoctor("Dr. Priya Patel", "Neurology", "priya@hospital.local", "9100000002", "DM", 8, "Female", "600", true);
            addDoctor("Dr. Rahul Mehta", "Orthopedics", "rahul@hospital.local", "9100000003", "MS", 15, "Male", "450", true);
            addDoctor("Dr. Sunita Rao", "Pediatrics", "sunita@hospital.local", "9100000004", "MD", 10, "Female", "400", true);
            addDoctor("Dr. Vikram Singh", "Dermatology", "vikram@hospital.local", "9100000005", "MD", 7, "Male", "350", false);
        }

        if (patients.count() == 0) {
            addPatient("Ravi Kumar", "9200000001", "ravi@example.com", LocalDate.of(1985, 4, 12), "Male", "O+");
            addPatient("Sneha Nair", "9200000002", "sneha@example.com", LocalDate.of(1992, 8, 25), "Female", "B+");
            addPatient("Mohan Das", "9200000003", "mohan@example.com", LocalDate.of(1970, 1, 3), "Male", "A-");
        }

        if (appointments.count() == 0) {
            List<Doctor> doctorList = doctors.findAllByOrderByFullNameAsc();
            List<Patient> patientList = patients.findAllByOrderByIdDesc();
            if (doctorList.size() >= 2 && patientList.size() >= 3) {
                LocalDate today = LocalDate.now();
                addAppointment(patientList.get(0), doctorList.get(0), today, LocalTime.of(10, 0), 1,
                        AppointmentStatus.COMPLETED, "Chest discomfort");
                addAppointment(patientList.get(1), doctorList.get(0), today, LocalTime.of(11, 30), 2,
                        AppointmentStatus.SCHEDULED, "Follow-up visit");
                addAppointment(patientList.get(2), doctorList.get(1), today, LocalTime.of(15, 0), 1,
                        AppointmentStatus.SCHEDULED, "Recurring headache");
            }
        }
        log.info("Ready. Sign in as admin (password from app.admin.password) or receptionist.");
    }

    private Role role(String name, String description) {
        return roles.findByName(name).orElseGet(() -> roles.save(new Role(name, description)));
    }

    private User user(String username, String password, String fullName, String email, String phone, Role role) {
        User user = new User();
        user.setUsername(username);
        user.setPassword(encoder.encode(password));
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        Set<Role> set = new HashSet<>();
        set.add(role);
        user.setRoles(set);
        return user;
    }

    private void addDoctor(String name, String specialization, String email, String phone, String qualification,
                           int experience, String gender, String fee, boolean available) {
        Doctor d = new Doctor();
        d.setFullName(name);
        d.setSpecialization(specialization);
        d.setEmail(email);
        d.setPhone(phone);
        d.setQualification(qualification);
        d.setExperienceYears(experience);
        d.setGender(gender);
        d.setConsultFee(new BigDecimal(fee));
        d.setAvailable(available);
        doctorService.save(d);
    }

    private void addPatient(String name, String phone, String email, LocalDate dob, String gender, String blood) {
        Patient p = new Patient();
        p.setFullName(name);
        p.setPhone(phone);
        p.setEmail(email);
        p.setDateOfBirth(dob);
        p.setGender(gender);
        p.setBloodGroup(blood);
        patientService.save(p);
    }

    private void addAppointment(Patient patient, Doctor doctor, LocalDate date, LocalTime time, int token,
                                AppointmentStatus status, String symptoms) {
        Appointment a = new Appointment();
        a.setPatient(patient);
        a.setDoctor(doctor);
        a.setAppointmentDate(date);
        a.setAppointmentTime(time);
        a.setTokenNo(token);
        a.setStatus(status);
        a.setSymptoms(symptoms);
        a.setBookedBy("receptionist");
        appointments.save(a);
    }
}
