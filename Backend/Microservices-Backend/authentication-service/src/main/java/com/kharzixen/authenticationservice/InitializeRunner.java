package com.kharzixen.authenticationservice;

import com.kharzixen.authenticationservice.model.User;
import com.kharzixen.authenticationservice.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
@AllArgsConstructor
@Slf4j
public class InitializeRunner implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        System.out.println("Application started!");

        // Example: Creating an admin user if it doesn't exist
        Optional<User> userOptional = userRepository.findByUsername("admin");
        if (userOptional.isEmpty()) {
            User adminUser = new User();
            adminUser.setUsername("admin");
            adminUser.setPassword(passwordEncoder.encode("123456"));
            adminUser.setIsAdmin(true);
            adminUser.setIsActive(true);
            User saved = userRepository.save(adminUser);
            log.info("Admin user created successfully. Username: {}, Password: {}",
                    saved.getUsername(), "123456");

        } else {
            log.info("Admin user already exists.");
        }
    }
}