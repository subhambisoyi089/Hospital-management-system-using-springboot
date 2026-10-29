package com.hospital.controller;

import com.hospital.entity.Doctor;
import com.hospital.exception.BusinessException;
import com.hospital.service.AppointmentService;
import com.hospital.service.DoctorService;
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
@RequestMapping("/doctors")
public class DoctorController {

    private final DoctorService doctorService;
    private final AppointmentService appointmentService;

    public DoctorController(DoctorService doctorService, AppointmentService appointmentService) {
        this.doctorService = doctorService;
        this.appointmentService = appointmentService;
    }

    @GetMapping
    public String list(@RequestParam(required = false, defaultValue = "") String q, Model model) {
        model.addAttribute("doctors", doctorService.search(q));
        model.addAttribute("q", q.trim());
        return "doctors/list";
    }

    @GetMapping("/new")
    @PreAuthorize("hasRole('ADMIN')")
    public String newForm(Model model) {
        model.addAttribute("doctor", new Doctor());
        return "doctors/form";
    }

    @GetMapping("/{id}/edit")
    @PreAuthorize("hasRole('ADMIN')")
    public String editForm(@PathVariable Long id, Model model) {
        model.addAttribute("doctor", doctorService.get(id));
        return "doctors/form";
    }

    @PostMapping("/save")
    @PreAuthorize("hasRole('ADMIN')")
    public String save(@ModelAttribute("doctor") Doctor doctor, Model model, RedirectAttributes flash) {
        try {
            Doctor saved = doctorService.save(doctor);
            flash.addFlashAttribute("success", saved.getFullName() + " saved.");
            return "redirect:/doctors/" + saved.getId();
        } catch (BusinessException ex) {
            model.addAttribute("error", ex.getMessage());
            return "doctors/form"; // the bound doctor is still in the model, so the form keeps what was typed
        }
    }

    @GetMapping("/{id}")
    public String view(@PathVariable Long id, Model model) {
        model.addAttribute("doctor", doctorService.get(id));
        model.addAttribute("appointments", appointmentService.forDoctor(id));
        return "doctors/view";
    }

    @PostMapping("/{id}/toggle")
    @PreAuthorize("hasRole('ADMIN')")
    public String toggle(@PathVariable Long id, RedirectAttributes flash) {
        doctorService.toggleAvailability(id);
        flash.addFlashAttribute("success", "Availability updated.");
        return "redirect:/doctors";
    }

    @PostMapping("/{id}/delete")
    @PreAuthorize("hasRole('ADMIN')")
    public String delete(@PathVariable Long id, RedirectAttributes flash) {
        doctorService.delete(id);
        flash.addFlashAttribute("success", "Doctor deleted.");
        return "redirect:/doctors";
    }
}
