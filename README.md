# Hospital Management System

A web-based front desk system for a hospital or clinic, built with **Java 17, Spring Boot 3, JSP/JSTL, Spring Security, Spring Data JPA (Hibernate)** and an **H2** file database.

Register patients, manage doctors, book appointments with queue tokens, and print appointment slips. Staff sign in as an **Administrator** or a **Receptionist**.

## Features

- **Dashboard** with today's numbers and a live queue: one column per doctor, with each patient's token coloured by status
- **Patients**: register, search by name, phone or patient ID, edit, and see the full appointment history. Patient IDs (PAT-10001...) never repeat
- **Doctors**: profile, specialization, fee, and an available/unavailable switch
- **Appointments** with booking rules that protect the schedule:
  - a doctor can't be booked twice at the same time
  - a patient can't have two appointments at the same time
  - past times and unavailable doctors are rejected
  - the booking form shows the times a doctor already has taken
- **Queue tokens** (T-001, T-002...) given per doctor per day, and a printable appointment slip
- **Status workflow**: Scheduled, then Completed, Cancelled or No show
- **Staff accounts** (admin only): add users, change roles, enable or disable, and delete
- **Security**: BCrypt passwords, role-based access, CSRF protection on every form, and no data-changing links (all changes are POST requests)

## Roles

| Action | Administrator | Receptionist |
|---|---|---|
| Dashboard, patients, appointments | yes | yes |
| View doctors | yes | yes |
| Add, edit or delete doctors | yes | no |
| Delete patients or appointments | yes | no |
| Staff accounts | yes | no |

## Requirements

- JDK 17 or newer
- Maven 3.8+, or an IDE that bundles it (Spring Tool Suite, IntelliJ IDEA, Eclipse)

## Run it

```bash
cd hospital-management
mvn spring-boot:run
```

In Spring Tool Suite: **File, Import, Maven, Existing Maven Projects**, choose the `hospital-management` folder, then right-click the project and choose **Run As, Spring Boot App**.

Open http://localhost:8081 and sign in:

| Username | Password | Role |
|---|---|---|
| admin | admin123 | Administrator |
| receptionist | rec123 | Receptionist |

On first run the app creates the database in the `data/` folder, with five sample doctors, three patients and a few appointments for today. Change the passwords after signing in (**Change password** in the sidebar), or set `ADMIN_PASSWORD` and `RECEPTIONIST_PASSWORD` environment variables before the first run.

## Configure

Everything is in `hospital-management/src/main/resources/application.properties`:

- `hospital.name`: shown in the sidebar, the login page and the appointment slip
- `server.port`: change it if 8081 is busy
- To use MySQL instead of H2, add the MySQL driver to `pom.xml` and change the `spring.datasource.*` lines

## Project structure

```
hospital-management/
├── pom.xml
└── src/main
    ├── java/com/hospital
    │   ├── config/          # security, first-run data
    │   ├── controller/      # request handlers and shared error handling
    │   ├── entity/          # User, Role, Doctor, Patient, Appointment
    │   ├── repository/      # Spring Data JPA interfaces
    │   ├── service/         # business rules (booking, validation, dashboard)
    │   └── exception/
    ├── resources            # application.properties and static css/js
    └── webapp/WEB-INF
        ├── views/           # JSP pages by area, plus layout/ for header and footer
        └── tags/            # small reusable JSP tags (csrf, status pill, money, appointment buttons)
```
