package com.hospital.controller;

import com.hospital.entity.Doctor;
import com.hospital.service.DoctorService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/doctors")
@RequiredArgsConstructor
public class DoctorController {

    private final DoctorService doctorService;

    @GetMapping
    public String list(@RequestParam(required = false) String search, Model model) {
        model.addAttribute("doctors",
            search != null && !search.isBlank() ? doctorService.search(search) : doctorService.findAll());
        model.addAttribute("search", search);
        return "admin/doctors/list";
    }

    @GetMapping("/new")
    @PreAuthorize("hasRole('ADMIN')")
    public String newForm(Model model) {
        model.addAttribute("doctor", new Doctor());
        return "admin/doctors/form";
    }

    @PostMapping("/save")
    @PreAuthorize("hasRole('ADMIN')")
    public String save(@ModelAttribute Doctor doctor, RedirectAttributes ra) {
        try {
            doctorService.save(doctor);
            ra.addFlashAttribute("success", "Doctor saved successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/doctors";
    }

    @GetMapping("/edit/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String edit(@PathVariable Long id, Model model) {
        doctorService.findById(id).ifPresent(d -> model.addAttribute("doctor", d));
        return "admin/doctors/form";
    }

    @GetMapping("/view/{id}")
    public String view(@PathVariable Long id, Model model) {
        doctorService.findById(id).ifPresent(d -> model.addAttribute("doctor", d));
        return "admin/doctors/view";
    }

    @GetMapping("/delete/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String delete(@PathVariable Long id, RedirectAttributes ra) {
        try {
            doctorService.deleteById(id);
            ra.addFlashAttribute("success", "Doctor deleted.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Cannot delete: " + e.getMessage());
        }
        return "redirect:/doctors";
    }

    @GetMapping("/toggle/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String toggle(@PathVariable Long id, RedirectAttributes ra) {
        doctorService.toggleAvailability(id);
        ra.addFlashAttribute("success", "Availability updated.");
        return "redirect:/doctors";
    }
}
