package com.hospital.controller;

import com.hospital.entity.Patient;
import com.hospital.service.AppointmentService;
import com.hospital.service.PatientService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/patients")
@RequiredArgsConstructor
public class PatientController {

    private final PatientService patientService;
    private final AppointmentService appointmentService;

    @GetMapping
    public String list(@RequestParam(required = false) String search, Model model) {
        model.addAttribute("patients",
            search != null && !search.isBlank() ? patientService.search(search) : patientService.findAll());
        model.addAttribute("search", search);
        return "receptionist/patients/list";
    }

    @GetMapping("/new")
    public String newForm(Model model) {
        model.addAttribute("patient", new Patient());
        return "receptionist/patients/form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute Patient patient, RedirectAttributes ra) {
        try {
            patientService.save(patient);
            ra.addFlashAttribute("success", "Patient registered successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/patients";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        patientService.findById(id).ifPresent(p -> model.addAttribute("patient", p));
        return "receptionist/patients/form";
    }

    @GetMapping("/view/{id}")
    public String view(@PathVariable Long id, Model model) {
        patientService.findById(id).ifPresent(p -> model.addAttribute("patient", p));
        model.addAttribute("appointments", appointmentService.findByPatient(id));
        return "receptionist/patients/view";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id, RedirectAttributes ra) {
        try {
            patientService.deleteById(id);
            ra.addFlashAttribute("success", "Patient deleted.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Cannot delete: " + e.getMessage());
        }
        return "redirect:/patients";
    }
}
