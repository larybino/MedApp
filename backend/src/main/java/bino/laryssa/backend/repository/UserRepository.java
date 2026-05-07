package bino.laryssa.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import bino.laryssa.backend.model.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
    List<User> findByMasterId(Long masterId);
    Optional<User> findByIdAndMasterId(Long id, Long masterId);
    Optional<User> findByEmailAndActiveTrue(String email);
    Optional<User> findByRecoveryCode(String recoveryCode);

}
