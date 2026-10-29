package com.hospital.entity;

public enum AppointmentStatus {
    SCHEDULED("Scheduled"), COMPLETED("Completed"), CANCELLED("Cancelled"), NO_SHOW("No show");

    private final String label;

    AppointmentStatus(String label) { this.label = label; }

    public String getLabel() { return label; }

    /** CSS class suffix, e.g. "noshow" (used as s-noshow). */
    public String getCss() { return name().toLowerCase().replace("_", ""); }
}
