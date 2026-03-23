package com.hospital.controller;

import com.hospital.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class DashboardController {

    private final DoctorService doctorService;
    private final PatientService patientService;
    private final AppointmentService appointmentService;

    @GetMapping("/home")
    public String home(Authentication auth, Model model) {
        model.addAttribute("totalDoctors",      doctorService.countTotal());
        model.addAttribute("availableDoctors",  doctorService.countAvailable());
        model.addAttribute("totalPatients",     patientService.countTotal());
        model.addAttribute("totalAppointments", appointmentService.countTotal());
        model.addAttribute("todayAppointments", appointmentService.countToday());
        model.addAttribute("scheduledCount",    appointmentService.countScheduled());
        model.addAttribute("recentAppointments",appointmentService.findAll().stream().limit(6).toList());

        boolean isAdmin = auth.getAuthorities().stream()
            .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        model.addAttribute("isAdmin", isAdmin);
        model.addAttribute("username", auth.getName());
        return "dashboard";
    }
}
