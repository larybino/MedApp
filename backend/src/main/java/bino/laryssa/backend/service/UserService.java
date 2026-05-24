package bino.laryssa.backend.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.thymeleaf.context.Context;

import bino.laryssa.backend.jwt.JwtUsersDetails;
import bino.laryssa.backend.exception.NotFoundException;
import bino.laryssa.backend.model.User;
import bino.laryssa.backend.model.UserRelationship;
import bino.laryssa.backend.model.dto.CreateMemberRequest;
import bino.laryssa.backend.model.dto.ForgotPasswordRequest;
import bino.laryssa.backend.model.dto.RegisterRequest;
import bino.laryssa.backend.model.dto.ResetPasswordRequest;
import bino.laryssa.backend.model.dto.UpdateUserRequest;
import bino.laryssa.backend.model.dto.UserResponse;
import bino.laryssa.backend.model.enums.Gender;
import bino.laryssa.backend.model.enums.UserRole;
import bino.laryssa.backend.repository.UserRelationshipRepository;
import bino.laryssa.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final UserRelationshipRepository userRelationshipRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;

    public UserResponse register(RegisterRequest request) {
        if(!request.getPassword().equals(request.getConfirmPassword())) {
            throw new IllegalArgumentException("As senhas não coincidem");
        }
        if(userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email já cadastrado");
        }
        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user = userRepository.save(user);

        return UserResponse.toResponse(user);
    }

    public UserResponse getById(Long id) {
        User user = userRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("Usuário não encontrado"));
        assertCanAccessUser(user);
        return UserResponse.toResponse(user);
    }

    public UserResponse update(Long id, UpdateUserRequest request) {
        User user = userRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("Usuário não encontrado"));
        assertCanAccessUser(user);
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setBirthDate(request.getBirthDate());
        user.setWeight(request.getWeight());
        user.setGender(Gender.valueOf(request.getGender()));
        user.setPhone(request.getPhone());
        user.setAssociation(request.getAssociation());
        user.setProfilePicture(request.getProfilePicture());
        user = userRepository.save(user);

        return UserResponse.toResponse(user);
    }

    public void delete(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Usuário não encontrado"));
        user.setActive(false);
        userRepository.save(user);
    }

   public UserResponse createMember(Long masterId, CreateMemberRequest request) {
        assertCurrentUserIsMaster(masterId);
        User master = userRepository.findById(masterId)
                .orElseThrow(() -> new NotFoundException("Master não encontrado"));
        User member;
        if ("LINK".equals(request.getMode())) {
            if (request.getMemberCode() == null || request.getMemberCode().isBlank())
                throw new IllegalArgumentException("Informe o código do membro");
            member = userRepository
                    .findByMemberCodeAndActiveTrue(request.getMemberCode())
                    .orElseThrow(() -> new NotFoundException("Código inválido ou não encontrado"));
        } else {
            if (request.getName() == null || request.getName().isBlank())
                throw new IllegalArgumentException("Nome é obrigatório");
            if (request.getEmail() != null && !request.getEmail().isBlank()) {
                if (userRepository.existsByEmail(request.getEmail()))
                    throw new IllegalArgumentException("Email já cadastrado");
            }
            member = new User();
            member.setName(request.getName());
            member.setRole(UserRole.MEMBER);
            if (request.getEmail() != null && !request.getEmail().isBlank())
                member.setEmail(request.getEmail());
            if (request.getPassword() != null && !request.getPassword().isBlank())
                member.setPassword(passwordEncoder.encode(request.getPassword()));
            member = userRepository.save(member);
        }

        if (userRelationshipRepository.existsByMaster_IdAndMember_Id(
                masterId, member.getId()))
            throw new IllegalArgumentException("Membro já vinculado a este master");

        UserRelationship relationship = new UserRelationship();
        relationship.setMaster(master);
        relationship.setMember(member);
        userRelationshipRepository.save(relationship);

        return UserResponse.toResponse(member);
    }

    public List<UserResponse> getMembersByMasterId(Long masterId) {
        assertCurrentUserIsMaster(masterId);
        return userRelationshipRepository.findByMaster_Id(masterId).stream().map(rel -> UserResponse.toResponse(rel.getMember())).toList();
    }

    public void removeMember(Long masterId, Long memberId) {
        assertCurrentUserIsMaster(masterId);
        UserRelationship relationship = userRelationshipRepository.findByMaster_IdAndMember_Id(masterId, memberId)
                .orElseThrow(() -> new NotFoundException("Membro não encontrado"));
        userRelationshipRepository.delete(relationship);
    }

    public void forgotPassword(ForgotPasswordRequest request) {
        User user = userRepository.findByEmailAndActiveTrue(request.getEmail())
                .orElseThrow(() -> new NotFoundException("Email não encontrado"));
        String recoveryCode = UUID.randomUUID().toString();
        user.setRecoveryCode(recoveryCode);
        user.setRecoveryCodeExpiration(LocalDateTime.now().plusHours(1));
        userRepository.save(user);
        sendForgotPasswordEmail(user, recoveryCode);
    }

    public void resetPassword(ResetPasswordRequest request) {
        if(!request.getNewPassword().equals(request.getConfirmNewPassword())) {
            throw new IllegalArgumentException("As senhas não coincidem");
        }
        User user = userRepository.findByRecoveryCode(request.getToken())
                .orElseThrow(() -> new NotFoundException("Código inválido"));
        if (user.getRecoveryCodeExpiration() == null
                || user.getRecoveryCodeExpiration().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Código expirado");
        }
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        user.setRecoveryCode(null);
        user.setRecoveryCodeExpiration(null);
        userRepository.save(user);
    }

    @Transactional
    public void changePassword(String oldPassword, String newPassword) {
        Long currentUserId = getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalArgumentException("Usuário não autenticado");
        }
        User user = userRepository.findById(currentUserId)
            .orElseThrow(() -> new NotFoundException("Usuário não encontrado"));
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new IllegalArgumentException("A senha antiga está incorreta.");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    private void assertCanAccessUser(User targetUser) {
        Long currentUserId = getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalArgumentException("Usuário não autenticado");
        }
        if (currentUserId.equals(targetUser.getId())) {
            return;
        }
        if (userRelationshipRepository.existsByMaster_IdAndMember_Id(currentUserId, targetUser.getId())) return;
        throw new IllegalArgumentException("Acesso negado");
    }

    private void assertCurrentUserIsMaster(Long masterId) {
        Long currentUserId = getCurrentUserId();
        if (currentUserId == null || !currentUserId.equals(masterId)) {
            throw new IllegalArgumentException("Acesso negado");
        }
    }

    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }
        Object principal = authentication.getPrincipal();
        if (principal instanceof JwtUsersDetails jwtUser) {
            return jwtUser.getId();
        }
        return null;
    }

    private void sendForgotPasswordEmail(User user, String recoveryCode) {
        Context context = new Context(LocaleContextHolder.getLocale());
        context.setVariable("name", user.getName());
        context.setVariable("recoveryCode", recoveryCode);
        emailService.sendEmailWithTemplate(
                user.getEmail(),
                "Recuperação de senha",
                context,
                "forgot-password-email"
        );
    }

}
