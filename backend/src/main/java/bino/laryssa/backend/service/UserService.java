package bino.laryssa.backend.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.thymeleaf.context.Context;

import bino.laryssa.backend.model.User;
import bino.laryssa.backend.model.dto.ForgotPasswordRequest;
import bino.laryssa.backend.model.dto.RegisterRequest;
import bino.laryssa.backend.model.dto.ResetPasswordRequest;
import bino.laryssa.backend.model.dto.UpdateUserRequest;
import bino.laryssa.backend.model.dto.UserResponse;
import bino.laryssa.backend.model.enums.Gender;
import bino.laryssa.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
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
        return userRepository.findById(id)
                .map(UserResponse::toResponse)
                .orElseThrow(() -> new IllegalArgumentException("Usuário não encontrado"));
    }

    public UserResponse update(Long id, UpdateUserRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Usuário não encontrado"));
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setBirthDate(request.getBirthDate());
        user.setGender(Gender.valueOf(request.getGender()));
        user.setPhone(request.getPhone());
        user.setAssociation(request.getAssociation());
        user.setProfilePicture(request.getProfilePicture());
        user = userRepository.save(user);

        return UserResponse.toResponse(user);
    }

    public void delete(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Usuário não encontrado"));
        user.setActive(false);
        userRepository.save(user);
    }

    public UserResponse createMember(Long masterId, RegisterRequest request) {
        if(userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email já cadastrado");
        }
        User master = userRepository.findById(masterId)
                .orElseThrow(() -> new IllegalArgumentException("Mestre não encontrado"));
        User member = new User();
        member.setName(request.getName());
        member.setEmail(request.getEmail());
        member.setPassword(passwordEncoder.encode(request.getPassword()));
        member.setMaster(master);
        member = userRepository.save(member);
        return UserResponse.toResponse(member);
    }

    public List<UserResponse> getMembersByMasterId(Long masterId) {
        return userRepository.findByMasterId(masterId)
                .stream()
                .map(UserResponse::toResponse)
                .toList();
    }

    public void removeMember(Long masterId, Long memberId) {
        User member = userRepository.findByIdAndMasterId(memberId, masterId)
                .orElseThrow(() -> new IllegalArgumentException("Membro não encontrado ou não pertence ao mestre"));
        member.setActive(false);
        userRepository.save(member);
    }

    public void forgotPassword(ForgotPasswordRequest request) {
        User user = userRepository.findByEmailAndActiveTrue(request.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("Email não encontrado"));
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
                .orElseThrow(() -> new IllegalArgumentException("Código inválido"));
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
    public void changePassword(String email, String oldPassword, String newPassword) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Usuário não encontrado"));
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new IllegalArgumentException("A senha antiga está incorreta.");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
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
