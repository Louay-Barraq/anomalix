package com.anomalix.backend.repository;

import com.anomalix.backend.model.BullAction;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface BullActionRepository extends JpaRepository<BullAction, Integer> {

    List<BullAction> findByNumDossier(String numDossier);

    List<BullAction> findByNumDossierAndEtat(String numDossier, String etat);
}