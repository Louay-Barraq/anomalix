package com.anomalix.backend.controller;

import com.anomalix.backend.dto.DossierRequest;
import com.anomalix.backend.model.Dossier;
import com.anomalix.backend.repository.DossierRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/dossiers")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class DossierController {

    private final DossierRepository dossierRepository;

    @GetMapping
    public ResponseEntity<List<Dossier>> getAll() {
        return ResponseEntity.ok(dossierRepository.findAll());
    }

    @GetMapping("/{numero}")
    public ResponseEntity<Dossier> getByNumero(@PathVariable String numero) {
        return dossierRepository.findByNumero(numero)
                .map(ResponseEntity::ok)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Dossier introuvable : " + numero
                ));
    }

    @GetMapping("/{numero}/famille")
    public ResponseEntity<List<Dossier>> getFamille(@PathVariable String numero) {
        return ResponseEntity.ok(
                dossierRepository.findByNumeroOrNumAdherent(numero, numero)
        );
    }

    @PostMapping
    public ResponseEntity<Dossier> create(
            @Valid @RequestBody DossierRequest request) {

        Dossier dossier = Dossier.builder()
                .numero(request.getNumero())
                .contrat(request.getContrat())
                .adhesion(request.getAdhesion())
                .nom(request.getNom())
                .prenom(request.getPrenom())
                .adresse(request.getAdresse())
                .emploi(request.getEmploi())
                .malade(request.getMalade())
                .dateNaissance(request.getDateNaissance())
                .build();

        return ResponseEntity.ok(dossierRepository.save(dossier));
    }
}