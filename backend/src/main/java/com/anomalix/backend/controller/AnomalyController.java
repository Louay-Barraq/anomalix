package com.anomalix.backend.controller;

import com.anomalix.backend.dto.AnomalyResponse;
import com.anomalix.backend.service.AnomalyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/anomalies")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AnomalyController {

    private final AnomalyService anomalyService;

    @PostMapping("/detect")
    public ResponseEntity<List<AnomalyResponse>> detect() {
        return ResponseEntity.ok(
                anomalyService.detectAndSave().stream()
                        .map(AnomalyResponse::fromEntity)
                        .toList()
        );
    }

    @GetMapping
    public ResponseEntity<List<AnomalyResponse>> getAll() {
        return ResponseEntity.ok(
                anomalyService.getAllAnomalies().stream()
                        .map(AnomalyResponse::fromEntity)
                        .toList()
        );
    }

    @GetMapping("/dossier/{numDossier}")
    public ResponseEntity<List<AnomalyResponse>> getByDossier(
            @PathVariable String numDossier) {
        return ResponseEntity.ok(
                anomalyService.getAnomaliesByDossier(numDossier).stream()
                        .map(AnomalyResponse::fromEntity)
                        .toList()
        );
    }
}