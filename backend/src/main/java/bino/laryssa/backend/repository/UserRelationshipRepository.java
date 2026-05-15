package bino.laryssa.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import bino.laryssa.backend.model.UserRelationship;

@Repository
public interface UserRelationshipRepository extends JpaRepository<UserRelationship, Long> {
    boolean existsByMaster_IdAndMember_Id(Long masterId, Long memberId);
    Optional<UserRelationship> findByMaster_IdAndMember_Id(Long masterId, Long memberId);
    List<UserRelationship> findByMaster_Id(Long masterId);
    List<UserRelationship> findByMember_Id(Long memberId);
}
