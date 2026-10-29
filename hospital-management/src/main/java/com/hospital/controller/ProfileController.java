package com.hospital.controller;

import com.hospital.exception.BusinessException;
import com.hospital.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/** Lets any signed-in user change their own password. */
@Controller
public class ProfileController {

    private final UserService userService;

    public ProfileController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/profile/password")
    public String form() {
        return "profile/password";
    }

    @PostMapping("/profile/password")
    public String change(@RequestParam String currentPassword,
                         @RequestParam String newPassword,
                         @RequestParam String confirmPassword,
                         Authentication auth, Model model, RedirectAttributes flash) {
        try {
            userService.changePassword(auth.getName(), currentPassword, newPassword, confirmPassword);
            flash.addFlashAttribute("success", "Your password was changed.");
            return "redirect:/";
        } catch (BusinessException ex) {
            model.addAttribute("error", ex.getMessage());
            return "profile/password";
        }
    }
}
