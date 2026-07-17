package com.anomalix.backend.service;

import com.anomalix.backend.dto.AuthRequest;
import com.anomalix.backend.dto.AuthResponse;
import com.anomalix.backend.dto.SwitchRoleRequest;
import com.anomalix.backend.repository.UtilisateurRepository;
import com.anomalix.backend.security.JwtService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class AuthService {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

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

                    List<String> allRoles = user.getRoles().stream()
                            .map(r -> r.getNom())
                            .toList();

                    // Rôle actif par défaut :
                    // Si l'utilisateur a ADHERENT → ADHERENT (priorité)
                    // Sinon ADMIN
                    String activeRole = allRoles.contains("ADHERENT")
                            ? "ADHERENT"
                            : "ADMIN";

                    String token = jwtService.generateToken(
                            user.getUsername(),
                            activeRole,
                            user.getNumDossier()
                    );

                    return AuthResponse.builder()
                            .success(true)
                            .token(token)
                            .role(activeRole)
                            .numDossier(user.getNumDossier())
                            .allRoles(allRoles)
                            .message("Connexion réussie")
                            .build();
                })
                .orElse(AuthResponse.builder()
                        .success(false)
                        .message("Utilisateur introuvable")
                        .build());
    }

    @Transactional(readOnly = true)
    public AuthResponse switchRole(String username, SwitchRoleRequest request) {
        return utilisateurRepository.findByUsername(username)
                .map(user -> {
                    List<String> allRoles = user.getRoles().stream()
                            .map(r -> r.getNom())
                            .toList();

                    // Vérifie que l'utilisateur a bien le rôle cible
                    if (!allRoles.contains(request.getTargetRole())) {
                        return AuthResponse.builder()
                                .success(false)
                                .message("Vous n'avez pas le rôle : " + request.getTargetRole())
                                .build();
                    }

                    // Génère un nouveau token avec le rôle cible
                    String newToken = jwtService.generateToken(
                            user.getUsername(),
                            request.getTargetRole(),
                            user.getNumDossier()
                    );

                    log.info("Issued new JWT on role switch for user={} role={} token={}",
                            user.getUsername(),
                            request.getTargetRole(),
                            newToken);

                    return AuthResponse.builder()
                            .success(true)
                            .token(newToken)
                            .role(request.getTargetRole())
                            .numDossier(user.getNumDossier())
                            .allRoles(allRoles)
                            .message("Rôle switché vers " + request.getTargetRole())
                            .build();
                })
                .orElse(AuthResponse.builder()
                        .success(false)
                        .message("Utilisateur introuvable")
                        .build());
    }
}