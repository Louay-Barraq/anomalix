/* package com.anomalix.backend.util;

import com.anomalix.backend.repository.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class PasswordHashMigration implements CommandLineRunner {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        log.info("Starting password hash migration...");

        utilisateurRepository.findAll().forEach(user -> {
            // Only hash if not already hashed (BCrypt hashes start with $2a$)
            if (!user.getPassword().startsWith("$2a$")) {
                String hashed = passwordEncoder.encode(user.getPassword());
                user.setPassword(hashed);
                utilisateurRepository.save(user);
                log.info("Hashed password for user: {}", user.getUsername());
            }
        });

        log.info("Password hash migration complete.");
    }
}
 */