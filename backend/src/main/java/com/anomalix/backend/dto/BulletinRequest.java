package com.anomalix.backend.dto;

import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class BulletinRequest {

    // Toujours obligatoire
    @NotBlank(message = "Le numéro de dossier est obligatoire")
    private String numDossier;

    @NotNull(message = "Le contrat est obligatoire")
    @Positive(message = "Le contrat doit être un nombre positif")
    private Integer contrat;

    @NotNull(message = "L'adhésion est obligatoire")
    @Positive(message = "L'adhésion doit être un nombre positif")
    private Long adhesion;

    @NotNull(message = "La date du soin est obligatoire")
    private LocalDate date;

    // Obligatoire seulement si nouveau membre (nouveauMembre = true)
    private Boolean nouveauMembre;
    private String nom;
    private String prenom;
    private String adresse;
    private String emploi;

    @Pattern(
            regexp = "adherent|conjoint|enfant",
            message = "Valeur invalide — doit être : adherent, conjoint ou enfant"
    )
    private String malade;

    private LocalDate dateNaissance;

    private String numAdherent;
}