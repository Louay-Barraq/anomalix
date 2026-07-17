package com.anomalix.backend.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Role")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Role {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true, length = 20)
    private String nom; // "ADMIN", "ADHERENT"
}