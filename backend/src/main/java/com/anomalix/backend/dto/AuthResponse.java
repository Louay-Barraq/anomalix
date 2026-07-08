package com.anomalix.backend.dto;

import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class AuthResponse {
    private boolean success;
    private String role;
    private String numDossier;
    private String message;
}