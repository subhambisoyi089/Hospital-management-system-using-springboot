package com.hospital.controller;

import com.hospital.entity.Appointment;
import com.hospital.entity.Appointment.Status;
import com.hospital.service.AppointmentService;
import com.hospital.service.DoctorService;
import com.hospital.service.PatientService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;

@Controller
@RequestMapping("/appointments")
@RequiredArgsConstructor
public class AppointmentController {

    private final AppointmentService appointmentService;
    private final DoctorService doctorService;
    private final PatientService patientService;

    @GetMapping
    public String list(@RequestParam(required = false)
                       @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
                       Model model) {
        model.addAttribute("appointments",
            date != null ? appointmentService.findByDate(date) : appointmentService.findAll());
        model.addAttribute("filterDate", date);
        return "receptionist/appointments/list";
    }

    @GetMapping("/today")
    public String today(Model model) {
        model.addAttribute("appointments", appointmentService.findToday());
        model.addAttribute("isToday", true);
        return "receptionist/appointments/list";
    }

    @GetMapping("/new")
    public String newForm(@RequestParam(required = false) Long patientId, Model model) {
        model.addAttribute("appointment", new Appointment());
        model.addAttribute("doctors", doctorService.findAvailable());
        model.addAttribute("patients", patientService.findAll());
        model.addAttribute("selectedPatientId", patientId);
        return "receptionist/appointments/form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute Appointment appointment,
                       @RequestParam Long patientId,
                       @RequestParam Long doctorId,
                       Authentication auth,
                       RedirectAttributes ra) {
        try {
            appointmentService.book(patientId, doctorId, appointment, auth.getName());
            ra.addFlashAttribute("success", "Appointment booked successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/appointments";
    }

    @GetMapping("/view/{id}")
    public String view(@PathVariable Long id, Model model) {
        appointmentService.findById(id).ifPresent(a -> model.addAttribute("appointment", a));
        return "receptionist/appointments/view";
    }

    @GetMapping("/status/{id}/{status}")
    public String updateStatus(@PathVariable Long id,
                               @PathVariable String status,
                               RedirectAttributes ra) {
        try {
            appointmentService.updateStatus(id, Status.valueOf(status));
            ra.addFlashAttribute("success", "Status updated to " + status);
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/appointments";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id, RedirectAttributes ra) {
        appointmentService.delete(id);
        ra.addFlashAttribute("success", "Appointment deleted.");
        return "redirect:/appointments";
    }
}
