package bino.laryssa.backend.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import bino.laryssa.backend.model.dto.ForgotPasswordRequest;
import bino.laryssa.backend.model.dto.ChangePasswordRequest;
import bino.laryssa.backend.model.dto.CreateMemberRequest;
import bino.laryssa.backend.model.dto.RegisterRequest;
import bino.laryssa.backend.model.dto.ResetPasswordRequest;
import bino.laryssa.backend.model.dto.UpdateUserRequest;
import bino.laryssa.backend.model.dto.UserResponse;
import bino.laryssa.backend.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @PostMapping("/register")
    public ResponseEntity<UserResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.status(201).body(userService.register(request));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('MASTER','MEMBER')")
    public ResponseEntity<UserResponse> getById(@PathVariable Long id) {
        return ResponseEntity.ok(userService.getById(id));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('MASTER','MEMBER')")
    public ResponseEntity<UserResponse> update(@PathVariable Long id, @Valid @RequestBody UpdateUserRequest request) {
        return ResponseEntity.ok(userService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        userService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<Void> forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        userService.forgotPassword(request);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/reset-password")
    public ResponseEntity<Void> resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        userService.resetPassword(request);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/change-password")
    @PreAuthorize("hasAnyRole('MASTER','MEMBER')")
    public ResponseEntity<Void> changePassword(@Valid @RequestBody ChangePasswordRequest request) {
        userService.changePassword(request.getEmail(), request.getOldPassword(), request.getNewPassword());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{masterId}/members")
    @PreAuthorize("hasRole('MASTER')")
    public ResponseEntity<UserResponse> createMember(@PathVariable Long masterId, @Valid @RequestBody CreateMemberRequest request) {
        return ResponseEntity.status(201).body(userService.createMember(masterId, request));
    }

    @GetMapping("/{masterId}/members")
    @PreAuthorize("hasRole('MASTER')")
    public ResponseEntity<List<UserResponse>> getMembers(@PathVariable Long masterId) {
        return ResponseEntity.ok(userService.getMembersByMasterId(masterId));
    }

    @DeleteMapping("/{masterId}/members/{memberId}")
    @PreAuthorize("hasRole('MASTER')")
    public ResponseEntity<Void> removeMember(@PathVariable Long masterId, @PathVariable Long memberId) {
        userService.removeMember(masterId, memberId);
        return ResponseEntity.noContent().build();
    }


}
