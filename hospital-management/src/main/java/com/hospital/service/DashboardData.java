package com.hospital.service;

import com.hospital.entity.Appointment;
import com.hospital.entity.AppointmentStatus;
import com.hospital.entity.Doctor;
import java.util.ArrayList;
import java.util.List;

/** Everything the dashboard shows. Plain getters so the JSP can read it. */
public class DashboardData {

    /** One doctor's tokens for today. */
    public static class DoctorQueue {
        private final Doctor doctor;
        private final List<Appointment> appointments = new ArrayList<>();

        public DoctorQueue(Doctor doctor) { this.doctor = doctor; }

        void add(Appointment appointment) { appointments.add(appointment); }

        public Doctor getDoctor() { return doctor; }
        public List<Appointment> getAppointments() { return appointments; }

        public long getWaiting() {
            return appointments.stream().filter(a -> a.getStatus() == AppointmentStatus.SCHEDULED).count();
        }
    }

    private final long totalPatients;
    private final long totalDoctors;
    private final long availableDoctors;
    private final long todayTotal;
    private final long todayWaiting;
    private final long todayDone;
    private final long upcoming;
    private final List<DoctorQueue> queues;

    public DashboardData(long totalPatients, long totalDoctors, long availableDoctors, long todayTotal,
                         long todayWaiting, long todayDone, long upcoming, List<DoctorQueue> queues) {
        this.totalPatients = totalPatients;
        this.totalDoctors = totalDoctors;
        this.availableDoctors = availableDoctors;
        this.todayTotal = todayTotal;
        this.todayWaiting = todayWaiting;
        this.todayDone = todayDone;
        this.upcoming = upcoming;
        this.queues = queues;
    }

    public long getTotalPatients() { return totalPatients; }
    public long getTotalDoctors() { return totalDoctors; }
    public long getAvailableDoctors() { return availableDoctors; }
    public long getTodayTotal() { return todayTotal; }
    public long getTodayWaiting() { return todayWaiting; }
    public long getTodayDone() { return todayDone; }
    public long getUpcoming() { return upcoming; }
    public List<DoctorQueue> getQueues() { return queues; }
}
