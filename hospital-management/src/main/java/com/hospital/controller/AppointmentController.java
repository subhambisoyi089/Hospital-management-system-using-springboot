package com.hospital.controller;

import com.hospital.entity.Appointment;
import com.hospital.entity.AppointmentStatus;
import com.hospital.exception.BusinessException;
import com.hospital.service.AppointmentService;
import com.hospital.service.DoctorService;
import com.hospital.service.PatientService;
import java.time.LocalDate;
import java.time.LocalTime;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/appointments")
public class AppointmentController {

    private final AppointmentService appointmentService;
    private final DoctorService doctorService;
    private final PatientService patientService;

    public AppointmentController(AppointmentService appointmentService, DoctorService doctorService,
                                 PatientService patientService) {
        this.appointmentService = appointmentService;
        this.doctorService = doctorService;
        this.patientService = patientService;
    }

    @GetMapping
    public String list(@RequestParam(required = false) LocalDate date,
                       @RequestParam(required = false) AppointmentStatus status,
                       @RequestParam(required = false) Long doctorId,
                       Model model) {
        model.addAttribute("appointments", appointmentService.list(date, status, doctorId));
        model.addAttribute("filterDate", date);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("selectedDoctorId", doctorId);
        model.addAttribute("doctors", doctorService.findAll());
        model.addAttribute("statuses", AppointmentStatus.values());
        return "appointments/list";
    }

    @GetMapping("/new")
    public String newForm(@RequestParam(required = false) Long patientId,
                          @RequestParam(required = false) Long doctorId,
                          Model model) {
        fillForm(model, new Appointment(), patientId, doctorId);
        return "appointments/form";
    }

    @PostMapping("/save")
    public String save(@RequestParam(required = false) Long patientId,
                       @RequestParam(required = false) Long doctorId,
                       @RequestParam(required = false) LocalDate appointmentDate,
                       @RequestParam(required = false) LocalTime appointmentTime,
                       @RequestParam(required = false) String symptoms,
                       @RequestParam(required = false) String notes,
                       Authentication auth, Model model, RedirectAttributes flash) {
        try {
            Appointment saved = appointmentService.book(patientId, doctorId, appointmentDate, appointmentTime,
                    symptoms, notes, auth.getName());
            flash.addFlashAttribute("success", "Appointment booked. Token " + saved.getToken() + " for "
                    + saved.getDoctor().getFullName() + ".");
            return "redirect:/appointments/" + saved.getId();
        } catch (BusinessException ex) {
            Appointment draft = new Appointment();
            draft.setAppointmentDate(appointmentDate);
            draft.setAppointmentTime(appointmentTime);
            draft.setSymptoms(symptoms);
            draft.setNotes(notes);
            model.addAttribute("error", ex.getMessage());
            fillForm(model, draft, patientId, doctorId);
            return "appointments/form";
        }
    }

    @GetMapping("/{id}")
    public String view(@PathVariable Long id, Model model) {
        model.addAttribute("appointment", appointmentService.get(id));
        return "appointments/view";
    }

    @PostMapping("/{id}/status")
    public String changeStatus(@PathVariable Long id,
                               @RequestParam AppointmentStatus status,
                               @RequestParam(required = false) String next,
                               RedirectAttributes flash) {
        appointmentService.changeStatus(id, status);
        flash.addFlashAttribute("success", "Appointment marked " + status.getLabel().toLowerCase() + ".");
        // only same-site paths are accepted as the page to return to
        boolean safe = next != null && next.startsWith("/") && !next.startsWith("//");
        return "redirect:" + (safe ? next : "/appointments/" + id);
    }

    @PostMapping("/{id}/delete")
    @PreAuthorize("hasRole('ADMIN')")
    public String delete(@PathVariable Long id, RedirectAttributes flash) {
        appointmentService.delete(id);
        flash.addFlashAttribute("success", "Appointment deleted.");
        return "redirect:/appointments";
    }

    private void fillForm(Model model, Appointment appointment, Long patientId, Long doctorId) {
        model.addAttribute("appointment", appointment);
        model.addAttribute("patients", patientService.findAll());
        model.addAttribute("doctorOptions", doctorService.findAvailable());
        model.addAttribute("selectedPatientId", patientId);
        model.addAttribute("selectedDoctorId", doctorId);
    }
}
