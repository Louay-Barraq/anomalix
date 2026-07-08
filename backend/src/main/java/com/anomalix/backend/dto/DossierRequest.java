package com.anomalix.backend.dto;

import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class DossierRequest {

    @NotBlank(message = "Le numéro de dossier est obligatoire")
    @Pattern(regexp = "N\\d{5}", message = "Format invalide — ex: N00001")
    private String numero;

    @NotNull(message = "Le contrat est obligatoire")
    @Positive(message = "Le contrat doit être un nombre positif")
    private Integer contrat;

    @NotNull(message = "L'adhésion est obligatoire")
    @Positive(message = "L'adhésion doit être un nombre positif")
    private Long adhesion;

    @NotBlank(message = "Le nom est obligatoire")
    @Size(max = 100, message = "Le nom ne peut pas dépasser 100 caractères")
    private String nom;

    @NotBlank(message = "Le prénom est obligatoire")
    @Size(max = 100, message = "Le prénom ne peut pas dépasser 100 caractères")
    private String prenom;

    @Size(max = 255, message = "L'adresse ne peut pas dépasser 255 caractères")
    private String adresse;

    @Size(max = 100, message = "L'emploi ne peut pas dépasser 100 caractères")
    private String emploi;

    @NotBlank(message = "Le champ malade est obligatoire")
    @Pattern(
            regexp = "adherent|conjoint|enfant",
            message = "Valeur invalide — doit être : adherent, conjoint ou enfant"
    )
    private String malade;

    @NotNull(message = "La date de naissance est obligatoire")
    @Past(message = "La date de naissance doit être dans le passé")
    private LocalDate dateNaissance;
}