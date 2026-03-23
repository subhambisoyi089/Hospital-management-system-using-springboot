package com.hospital.service;

import com.hospital.entity.Role;
import com.hospital.entity.User;
import com.hospital.repository.RoleRepository;
import com.hospital.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;

@Service
@RequiredArgsConstructor
@Transactional
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    public List<User> findAll() { return userRepository.findAll(); }
    public Optional<User> findById(Long id) { return userRepository.findById(id); }
    public Optional<User> findByUsername(String username) { return userRepository.findByUsername(username); }

    public User save(User user, Set<String> roleNames) {
        if (user.getId() == null) {
            if (userRepository.existsByUsername(user.getUsername()))
                throw new IllegalArgumentException("Username already taken.");
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        } else {
            User existing = userRepository.findById(user.getId()).orElseThrow();
            if (user.getPassword() == null || user.getPassword().isBlank())
                user.setPassword(existing.getPassword());
            else
                user.setPassword(passwordEncoder.encode(user.getPassword()));
        }
        Set<Role> roles = new HashSet<>();
        for (String rn : roleNames) roleRepository.findByName(rn).ifPresent(roles::add);
        user.setRoles(roles);
        return userRepository.save(user);
    }

    public void delete(Long id) { userRepository.deleteById(id); }
    public void toggleStatus(Long id) {
        User u = userRepository.findById(id).orElseThrow();
        u.setEnabled(!u.isEnabled());
        userRepository.save(u);
    }
}
