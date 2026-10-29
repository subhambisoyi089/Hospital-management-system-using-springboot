package com.hospital.controller;

import com.hospital.service.AppointmentService;
import java.time.LocalDate;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/** JSON used by the booking form to show which times a doctor already has taken. */
@RestController
public class ApiController {

    private final AppointmentService appointmentService;

    public ApiController(AppointmentService appointmentService) {
        this.appointmentService = appointmentService;
    }

    @GetMapping("/api/booked-times")
    public ResponseEntity<List<String>> bookedTimes(@RequestParam(required = false) Long doctorId,
                                                    @RequestParam(required = false) LocalDate date) {
        if (doctorId == null || date == null) {
            return ResponseEntity.badRequest().body(List.of());
        }
        return ResponseEntity.ok(appointmentService.bookedTimes(doctorId, date));
    }
}
