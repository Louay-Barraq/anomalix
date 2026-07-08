package com.anomalix.backend.controller;

import com.anomalix.backend.dto.BulletinRequest;
import com.anomalix.backend.service.BulletinService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/bulletins")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class BulletinController {

    private final BulletinService bulletinService;

    @PostMapping
    public ResponseEntity<Void> soumettre(
            @Valid @RequestBody BulletinRequest request) {
        bulletinService.soumettreBulletin(request);
        return ResponseEntity.ok().build();
    }
}