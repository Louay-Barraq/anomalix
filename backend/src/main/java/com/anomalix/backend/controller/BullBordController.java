package com.anomalix.backend.controller;

import com.anomalix.backend.model.BullBord;
import com.anomalix.backend.repository.BullBordRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bullbord")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class BullBordController {

    private final BullBordRepository bullBordRepository;

    // Tous les bulletins
    @GetMapping
    public ResponseEntity<List<BullBord>> getAll() {
        return ResponseEntity.ok(bullBordRepository.findAll());
    }

    // Bulletins bloqués uniquement
    @GetMapping("/bloques")
    public ResponseEntity<List<BullBord>> getBloques() {
        return ResponseEntity.ok(
                bullBordRepository.findByEtatIn(List.of("IS", "ES", "IV", "EV"))
        );
    }

    // Bulletins d'un dossier spécifique
    @GetMapping("/dossier/{numDossier}")
    public ResponseEntity<List<BullBord>> getByDossier(@PathVariable String numDossier) {
        return ResponseEntity.ok(bullBordRepository.findByNumDossier(numDossier));
    }

    @PostMapping("/famille")
    public ResponseEntity<List<BullBord>> getByFamille(
            @RequestBody List<String> numDossiers) {
        return ResponseEntity.ok(
                bullBordRepository.findByNumDossierIn(numDossiers)
        );
    }
}