package com.hospital.exception;

/** A problem the user can fix (for example a doctor who is already booked). The message is shown on screen. */
public class BusinessException extends RuntimeException {

    public BusinessException(String message) {
        super(message);
    }
}
