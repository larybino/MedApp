package bino.laryssa.backend.jwt;

import bino.laryssa.backend.model.User;
import bino.laryssa.backend.model.enums.UserRole;
import bino.laryssa.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;

@RequiredArgsConstructor
@Service
public class JwtUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.expire-hours:24}")
    private long expireHours;

    // Configura o JwtUtils com os valores do properties após injeção
    @PostConstruct
    public void init() {
        JwtUtils.configure(secret, expireHours);
    }

    @Override
    public JwtUsersDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmailAndActiveTrue(email)
                .orElseThrow(() -> new UsernameNotFoundException(
                        "Usuário não encontrado com email: " + email));
        return new JwtUsersDetails(user);
    }

    public JwtToken getTokenAuthenticated(String email) {
        UserRole role = userRepository.findByEmailAndActiveTrue(email)
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado"))
                .getRole();
        return JwtUtils.createToken(email, role.name());
    }
}