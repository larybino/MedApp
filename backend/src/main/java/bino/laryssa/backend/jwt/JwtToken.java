package bino.laryssa.backend.jwt;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class JwtToken {
    private String token;
    private Long id;
    private String role;
}
