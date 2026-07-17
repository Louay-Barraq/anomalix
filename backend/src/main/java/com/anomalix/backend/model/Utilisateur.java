package com.anomalix.backend.model;

import jakarta.persistence.*;
import lombok.*;
import java.util.Set;

@Entity
@Table(name = "Utilisateur")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Utilisateur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false, length = 255)
    private String password;

    @Column(name = "num_dossier", length = 20)
    private String numDossier;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "UtilisateurRole",
            joinColumns = @JoinColumn(name = "utilisateur_id"),
            inverseJoinColumns = @JoinColumn(name = "role_id")
    )
    private Set<Role> roles;

    public boolean hasRole(String roleName) {
        return roles != null && roles.stream()
                .anyMatch(r -> r.getNom().equals(roleName));
    }

    public boolean hasMultipleRoles() {
        return roles != null && roles.size() > 1;
    }
}