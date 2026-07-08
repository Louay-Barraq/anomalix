package com.anomalix.backend.service;

import com.anomalix.backend.dto.BulletinRequest;
import com.anomalix.backend.model.*;
import com.anomalix.backend.repository.*;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class BulletinService {

    private final BullBordRepository bullBordRepository;
    private final BullActionRepository bullActionRepository;
    private final DossierRepository dossierRepository;

    @Transactional
    public void soumettreBulletin(BulletinRequest request) {

        // Cas 2b — nouveau membre : créer le dossier d'abord
        if (Boolean.TRUE.equals(request.getNouveauMembre())) {
            validateNouveauMembre(request);

            Dossier dossier = Dossier.builder()
                    .numero(request.getNumDossier())
                    .contrat(request.getContrat())
                    .adhesion(request.getAdhesion())
                    .nom(request.getNom())
                    .prenom(request.getPrenom())
                    .adresse(request.getAdresse())
                    .emploi(request.getEmploi())
                    .malade(request.getMalade())
                    .dateNaissance(request.getDateNaissance())
                    .numAdherent(request.getNumAdherent())
                    .build();

            dossierRepository.save(dossier);

        } else {
            // Cas 2a — dossier existant : vérifier qu'il existe
            dossierRepository.findByNumero(request.getNumDossier())
                    .orElseThrow(() -> new EntityNotFoundException(
                            "Dossier introuvable : " + request.getNumDossier()
                    ));
        }

        // Dans les deux cas : insérer dans BullBord et BullAction
        BullBord bullBord = BullBord.builder()
                .etat("IS")
                .numDossier(request.getNumDossier())
                .date(request.getDate())
                .contrat(request.getContrat())
                .adhesion(request.getAdhesion())
                .build();
        bullBordRepository.save(bullBord);

        BullAction bullAction = BullAction.builder()
                .etat("TS")
                .idEtat(3)
                .numDossier(request.getNumDossier())
                .build();
        bullActionRepository.save(bullAction);
    }

    private void validateNouveauMembre(BulletinRequest request) {
        if (request.getNom() == null || request.getNom().isBlank())
            throw new IllegalArgumentException("Le nom est obligatoire pour un nouveau membre");
        if (request.getPrenom() == null || request.getPrenom().isBlank())
            throw new IllegalArgumentException("Le prénom est obligatoire pour un nouveau membre");
        if (request.getMalade() == null || request.getMalade().isBlank())
            throw new IllegalArgumentException("Le type de malade est obligatoire pour un nouveau membre");
        if (request.getDateNaissance() == null)
            throw new IllegalArgumentException("La date de naissance est obligatoire pour un nouveau membre");
    }
}