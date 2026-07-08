package com.anomalix.backend.repository;

import com.anomalix.backend.model.BullActionRevalidation;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface BullActionRevalidationRepository extends JpaRepository<BullActionRevalidation, Integer> {

    List<BullActionRevalidation> findByNumDossier(String numDossier);
}