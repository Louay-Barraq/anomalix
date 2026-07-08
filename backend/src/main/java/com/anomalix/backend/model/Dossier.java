package com.anomalix.backend.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Entity
@Table(name = "Dossier")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Dossier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true, length = 20)
    private String numero;

    @Column(nullable = false)
    private Integer contrat;

    @Column(nullable = false)
    private Long adhesion;

    @Column(nullable = false, length = 100)
    private String nom;

    @Column(nullable = false, length = 100)
    private String prenom;

    @Column(length = 255)
    private String adresse;

    @Column(length = 100)
    private String emploi;

    @Column(name = "num_adherent", length = 20)
    private String numAdherent;

    @Column(nullable = false, length = 20)
    private String malade; // "adherent", "conjoint", "enfant"

    @Column(name = "date_naissance", nullable = false)
    private LocalDate dateNaissance;
}