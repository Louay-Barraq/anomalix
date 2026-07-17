package com.anomalix.backend.controller;

import com.anomalix.backend.dto.AuthRequest;
import com.anomalix.backend.dto.AuthResponse;
import com.anomalix.backend.dto.SwitchRoleRequest;
import com.anomalix.backend.security.JwtService;
import com.anomalix.backend.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {

    private final AuthService authService;
    private final JwtService jwtService;

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(
            @Valid @RequestBody AuthRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @PostMapping("/switch-role")
    public ResponseEntity<AuthResponse> switchRole(
            @Valid @RequestBody SwitchRoleRequest request,
            @RequestHeader("Authorization") String authHeader) {

        // Extrait le username du token actuel
        String token = authHeader.substring(7);
        String username = jwtService.extractUsername(token);

        return ResponseEntity.ok(authService.switchRole(username, request));
    }
}