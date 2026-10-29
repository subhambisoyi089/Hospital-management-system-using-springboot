package com.hospital.service;

import com.hospital.exception.BusinessException;
import java.util.regex.Pattern;

/** Small checks shared by the services. */
final class Validation {

    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    private Validation() { }

    static String clean(String value) {
        return (value == null || value.isBlank()) ? null : value.trim();
    }

    static String required(String value, String message) {
        if (value == null || value.isBlank()) {
            throw new BusinessException(message);
        }
        return value.trim();
    }

    static String phone(String value) {
        String phone = required(value, "Enter a phone number.");
        if (phone.replaceAll("\\D", "").length() < 7) {
            throw new BusinessException("Enter a valid phone number.");
        }
        return phone;
    }

    static String email(String value, boolean mandatory) {
        String email = clean(value);
        if (email == null) {
            if (mandatory) {
                throw new BusinessException("Enter an email address.");
            }
            return null;
        }
        if (!EMAIL.matcher(email).matches()) {
            throw new BusinessException("Enter a valid email address.");
        }
        return email.toLowerCase();
    }
}
