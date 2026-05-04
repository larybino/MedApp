package bino.laryssa.backend.controller;

import bino.laryssa.backend.jwt.JwtToken;
import bino.laryssa.backend.jwt.JwtUserDetailsService;
import bino.laryssa.backend.model.dto.LoginRequest;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/auth")
public class AuthController {

    private final JwtUserDetailsService jwtUserDetailsService;
    private final AuthenticationManager authenticationManager;

    @PostMapping("/login")
    public ResponseEntity<JwtToken> login(@Valid @RequestBody LoginRequest request,
                                          HttpServletRequest httpRequest) {
        log.info("Tentativa de login: {}", request.getEmail());
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getEmail(), request.getPassword()));
        } catch (AuthenticationException ex) {
            log.warn("Credenciais inválidas para: {}", request.getEmail());
            return ResponseEntity.badRequest().build();
        }

        JwtToken token = jwtUserDetailsService.getTokenAuthenticated(request.getEmail());
        return ResponseEntity.ok(token);
    }
}