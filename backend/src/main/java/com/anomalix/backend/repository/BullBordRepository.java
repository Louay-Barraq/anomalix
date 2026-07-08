package com.anomalix.backend.repository;

import com.anomalix.backend.model.BullBord;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface BullBordRepository extends JpaRepository<BullBord, Integer> {

    List<BullBord> findByEtat(String etat);

    List<BullBord> findByEtatIn(List<String> etats);

    List<BullBord> findByNumDossier(String numDossier);

    List<BullBord> findByNumDossierIn(List<String> numDossiers);
}