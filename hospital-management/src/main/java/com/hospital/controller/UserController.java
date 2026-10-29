package com.hospital.controller;

import com.hospital.entity.User;
import com.hospital.exception.BusinessException;
import com.hospital.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/** Staff accounts. Admin only (see SecurityConfig). */
@Controller
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("users", userService.findAll());
        return "users/list";
    }

    @GetMapping("/new")
    public String newForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("selectedRole", "ROLE_RECEPTIONIST");
        model.addAttribute("roleOptions", userService.allRoles());
        return "users/form";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        User user = userService.get(id);
        model.addAttribute("user", user);
        model.addAttribute("selectedRole", user.getRoleName());
        model.addAttribute("roleOptions", userService.allRoles());
        return "users/form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute("user") User user,
                       @RequestParam(required = false) String role,
                       Authentication auth, Model model, RedirectAttributes flash) {
        try {
            User saved = userService.save(user, role, auth.getName());
            flash.addFlashAttribute("success", "User " + saved.getUsername() + " saved.");
            return "redirect:/users";
        } catch (BusinessException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("selectedRole", role);
            model.addAttribute("roleOptions", userService.allRoles());
            return "users/form";
        }
    }

    @PostMapping("/{id}/toggle")
    public String toggle(@PathVariable Long id, Authentication auth, RedirectAttributes flash) {
        User user = userService.toggleEnabled(id, auth.getName());
        flash.addFlashAttribute("success", user.getUsername() + (user.isEnabled() ? " enabled." : " disabled."));
        return "redirect:/users";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id, Authentication auth, RedirectAttributes flash) {
        userService.delete(id, auth.getName());
        flash.addFlashAttribute("success", "User deleted.");
        return "redirect:/users";
    }
}
