package com.anomalix.backend.service;

import com.anomalix.backend.dto.AuthRequest;
import com.anomalix.backend.dto.AuthResponse;
import com.anomalix.backend.repository.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public AuthResponse login(AuthRequest request) {
        return utilisateurRepository.findByUsername(request.getUsername())
                .map(user -> {
                    if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
                        return AuthResponse.builder()
                                .success(false)
                                .message("Mot de passe incorrect")
                                .build();
                    }
                    return AuthResponse.builder()
                            .success(true)
                            .role(user.getRole())
                            .numDossier(user.getNumDossier())
                            .message("Connexion réussie")
                            .build();
                })
                .orElse(AuthResponse.builder()
                        .success(false)
                        .message("Utilisateur introuvable")
                        .build());
    }
}