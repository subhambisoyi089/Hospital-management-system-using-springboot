package com.hospital.service;

import com.hospital.entity.Role;
import com.hospital.entity.User;
import com.hospital.exception.BusinessException;
import com.hospital.repository.RoleRepository;
import com.hospital.repository.UserRepository;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Pattern;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

    private static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9._-]{3,30}$");
    private static final int MIN_PASSWORD = 6;

    private final UserRepository users;
    private final RoleRepository roles;
    private final PasswordEncoder encoder;

    public UserService(UserRepository users, RoleRepository roles, PasswordEncoder encoder) {
        this.users = users;
        this.roles = roles;
        this.encoder = encoder;
    }

    @Transactional(readOnly = true)
    public List<User> findAll() {
        return users.findAllByOrderByUsernameAsc();
    }

    @Transactional(readOnly = true)
    public List<Role> allRoles() {
        return roles.findAll();
    }

    @Transactional(readOnly = true)
    public User get(Long id) {
        return users.findById(id).orElseThrow(() -> new BusinessException("That user was not found."));
    }

    /**
     * Creates a user (form id == null) or updates one. On update, a blank password keeps the old one.
     * The signed-in admin can't remove their own admin access or disable themselves.
     */
    @Transactional
    public User save(User form, String roleName, String currentUsername) {
        String fullName = Validation.required(form.getFullName(), "Enter the user's full name.");
        String email = Validation.email(form.getEmail(), true);
        Role role = roles.findByName(roleName == null ? "" : roleName)
                .orElseThrow(() -> new BusinessException("Choose a role."));
        String password = form.getPassword();
        boolean hasPassword = password != null && !password.isBlank();
        if (hasPassword && password.length() < MIN_PASSWORD) {
            throw new BusinessException("The password must be at least " + MIN_PASSWORD + " characters.");
        }

        User user;
        if (form.getId() == null) {
            String username = Validation.required(form.getUsername(), "Enter a username.");
            if (!USERNAME.matcher(username).matches()) {
                throw new BusinessException("The username must be 3 to 30 letters, digits, dots, dashes or underscores.");
            }
            if (users.existsByUsername(username)) {
                throw new BusinessException("The username \"" + username + "\" is already taken.");
            }
            if (users.existsByEmail(email)) {
                throw new BusinessException("Another user already uses this email.");
            }
            if (!hasPassword) {
                throw new BusinessException("Enter a password of at least " + MIN_PASSWORD + " characters.");
            }
            user = new User();
            user.setUsername(username);
        } else {
            user = get(form.getId());
            if (users.existsByEmailAndIdNot(email, user.getId())) {
                throw new BusinessException("Another user already uses this email.");
            }
            if (user.getUsername().equals(currentUsername)) {
                if (!"ROLE_ADMIN".equals(role.getName())) {
                    throw new BusinessException("You can't remove your own admin access.");
                }
                if (!form.isEnabled()) {
                    throw new BusinessException("You can't disable your own account.");
                }
            }
        }

        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(Validation.clean(form.getPhone()));
        user.setEnabled(form.isEnabled());
        Set<Role> newRoles = new HashSet<>();
        newRoles.add(role);
        user.setRoles(newRoles);
        if (hasPassword) {
            user.setPassword(encoder.encode(password));
        }
        return users.save(user);
    }

    @Transactional
    public User toggleEnabled(Long id, String currentUsername) {
        User user = get(id);
        if (user.getUsername().equals(currentUsername)) {
            throw new BusinessException("You can't disable your own account.");
        }
        user.setEnabled(!user.isEnabled());
        return users.save(user);
    }

    @Transactional
    public void delete(Long id, String currentUsername) {
        User user = get(id);
        if (user.getUsername().equals(currentUsername)) {
            throw new BusinessException("You can't delete your own account.");
        }
        users.delete(user);
    }

    @Transactional
    public void changePassword(String username, String current, String newPassword, String confirm) {
        User user = users.findByUsername(username).orElseThrow(() -> new BusinessException("User not found."));
        if (current == null || !encoder.matches(current, user.getPassword())) {
            throw new BusinessException("The current password is wrong.");
        }
        if (newPassword == null || newPassword.length() < MIN_PASSWORD) {
            throw new BusinessException("The new password must be at least " + MIN_PASSWORD + " characters.");
        }
        if (!newPassword.equals(confirm)) {
            throw new BusinessException("The new password and its confirmation don't match.");
        }
        user.setPassword(encoder.encode(newPassword));
        users.save(user);
    }
}
