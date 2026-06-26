package bino.laryssa.backend.jwt;

import bino.laryssa.backend.model.User;
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

    @PostConstruct
    public void init() {
        JwtUtils.configure(secret, expireHours);
    }

    @Override
    public JwtUsersDetails loadUserByUsername(String id) {
        User user = userRepository.findById(Long.parseLong(id))
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado"));
        return new JwtUsersDetails(user);
    }

    public JwtToken getTokenAuthenticated(String email) {
        User user = userRepository.findByEmailAndActiveTrue(email)
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado"));
        return JwtUtils.createToken(String.valueOf(user.getId()), user.getRole().name(), user.getId());
    }
}