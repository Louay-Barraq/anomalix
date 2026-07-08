package com.anomalix.backend.repository;

import com.anomalix.backend.model.Dossier;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface DossierRepository extends JpaRepository<Dossier, Integer> {
    Optional<Dossier> findByNumero(String numero);
    List<Dossier> findByNumeroOrNumAdherent(String numero, String numAdherent);
}