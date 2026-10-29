package com.hospital.controller;

import com.hospital.exception.BusinessException;
import jakarta.servlet.http.HttpServletRequest;
import java.net.URI;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.support.RequestContextUtils;

/** Values every page needs, plus friendly handling of problems the user can fix. */
@ControllerAdvice
public class GlobalControllerAdvice {

    private final String hospitalName;

    public GlobalControllerAdvice(@Value("${hospital.name}") String hospitalName) {
        this.hospitalName = hospitalName;
    }

    @ModelAttribute("hospitalName")
    public String hospitalName() {
        return hospitalName;
    }

    /** Today as yyyy-MM-dd, for the min attribute of date inputs. */
    @ModelAttribute("today")
    public String today() {
        return LocalDate.now().toString();
    }

    @ModelAttribute("todayText")
    public String todayText() {
        return LocalDate.now().format(DateTimeFormatter.ofPattern("EEEE, dd MMM yyyy", Locale.ENGLISH));
    }

    @ModelAttribute("username")
    public String username() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth instanceof AnonymousAuthenticationToken || !auth.isAuthenticated()) {
            return null;
        }
        return auth.getName();
    }

    @ModelAttribute("isAdmin")
    public boolean isAdmin() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth != null && auth.isAuthenticated()
                && auth.getAuthorities().stream().anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));
    }

    @ExceptionHandler(BusinessException.class)
    public String handleBusiness(BusinessException ex, HttpServletRequest request) {
        return backWithError(request, ex.getMessage());
    }

    @ExceptionHandler({MissingServletRequestParameterException.class, MethodArgumentTypeMismatchException.class})
    public String handleBadInput(HttpServletRequest request) {
        return backWithError(request, "Some values are missing or invalid. Check the form and try again.");
    }

    /** Flash the message and go back to the page the user came from. */
    private String backWithError(HttpServletRequest request, String message) {
        FlashMap flash = RequestContextUtils.getOutputFlashMap(request);
        if (flash != null) {
            flash.put("error", message);
        }
        return "redirect:" + previousPath(request);
    }

    private String previousPath(HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        if (referer != null) {
            try {
                URI uri = URI.create(referer);
                String path = uri.getRawPath();
                String context = request.getContextPath();
                if (path != null && !context.isEmpty() && path.startsWith(context)) {
                    path = path.substring(context.length());
                }
                // Only same-site paths; "//host" would be an open redirect.
                if (path != null && path.startsWith("/") && !path.startsWith("//")
                        && !path.equals(request.getRequestURI())) {
                    return uri.getRawQuery() == null ? path : path + "?" + uri.getRawQuery();
                }
            } catch (IllegalArgumentException ignored) {
                // bad Referer header, use the home page
            }
        }
        return "/";
    }
}
