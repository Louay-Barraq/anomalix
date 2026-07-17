package com.anomalix.backend.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class SwitchRoleRequest {

    @NotBlank(message = "Le rôle cible est obligatoire")
    private String targetRole; // "ADMIN" ou "ADHERENT"
}