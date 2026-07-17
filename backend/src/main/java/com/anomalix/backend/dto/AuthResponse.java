package com.anomalix.backend.dto;

import lombok.*;
        import java.util.List;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class AuthResponse {
    private boolean success;
    private String token;
    private String role;           // rôle actif dans ce token
    private String numDossier;
    private List<String> allRoles; // tous les rôles de l'utilisateur
    private String message;
}