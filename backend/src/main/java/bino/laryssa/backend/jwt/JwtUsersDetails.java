package bino.laryssa.backend.jwt;

import bino.laryssa.backend.model.User;
import org.springframework.security.core.authority.AuthorityUtils;

public class JwtUsersDetails extends org.springframework.security.core.userdetails.User {

    private final User user;

    public JwtUsersDetails(User user) {
        super(user.getEmail(), user.getPassword(),
                AuthorityUtils.createAuthorityList(user.getRole().name()));
        this.user = user;
    }

    public Long getId() {
        return user.getId();
    }

    public String getRole() {
        return user.getRole().name();
    }
}