package com.hospital.controller;

import com.hospital.entity.Patient;
import com.hospital.exception.BusinessException;
import com.hospital.service.AppointmentService;
import com.hospital.service.PatientService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/patients")
public class PatientController {

    private final PatientService patientService;
    private final AppointmentService appointmentService;

    public PatientController(PatientService patientService, AppointmentService appointmentService) {
        this.patientService = patientService;
        this.appointmentService = appointmentService;
    }

    @GetMapping
    public String list(@RequestParam(required = false, defaultValue = "") String q, Model model) {
        model.addAttribute("patients", patientService.search(q));
        model.addAttribute("q", q.trim());
        return "patients/list";
    }

    @GetMapping("/new")
    public String newForm(Model model) {
        model.addAttribute("patient", new Patient());
        return "patients/form";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        model.addAttribute("patient", patientService.get(id));
        return "patients/form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute("patient") Patient patient, Model model, RedirectAttributes flash) {
        try {
            Patient saved = patientService.save(patient);
            flash.addFlashAttribute("success", saved.getFullName() + " saved as " + saved.getPatientId() + ".");
            return "redirect:/patients/" + saved.getId();
        } catch (BusinessException ex) {
            model.addAttribute("error", ex.getMessage());
            return "patients/form";
        }
    }

    @GetMapping("/{id}")
    public String view(@PathVariable Long id, Model model) {
        model.addAttribute("patient", patientService.get(id));
        model.addAttribute("appointments", appointmentService.forPatient(id));
        return "patients/view";
    }

    @PostMapping("/{id}/delete")
    @PreAuthorize("hasRole('ADMIN')")
    public String delete(@PathVariable Long id, RedirectAttributes flash) {
        patientService.delete(id);
        flash.addFlashAttribute("success", "Patient deleted.");
        return "redirect:/patients";
    }
}
