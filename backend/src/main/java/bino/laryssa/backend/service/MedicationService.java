package bino.laryssa.backend.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import bino.laryssa.backend.exception.NotFoundException;
import bino.laryssa.backend.jwt.JwtUsersDetails;
import bino.laryssa.backend.model.Medication;
import bino.laryssa.backend.model.User;
import bino.laryssa.backend.model.dto.MedicationRequest;
import bino.laryssa.backend.model.dto.MedicationResponse;
import bino.laryssa.backend.model.enums.TreatmentStatus;
import bino.laryssa.backend.repository.MedicationRepository;
import bino.laryssa.backend.repository.UserRelationshipRepository;
import bino.laryssa.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MedicationService {
    private final MedicationRepository medicationRepository;
    private final UserRepository userRepository;
    private final UserRelationshipRepository userRelationshipRepository;

    public MedicationResponse create(MedicationRequest request) {
        Long currentUserId = getCurrentUserId();

        Long targetUserId = request.getUserId() != null
                ? request.getUserId()
                : currentUserId;

        assertCanAccessUser(targetUserId);

        User targetUser = userRepository.findById(targetUserId)
                .orElseThrow(() -> new NotFoundException("Usuário não encontrado"));

        Medication medication = new Medication();
        medication.setName(request.getName());
        medication.setDosage(request.getDosage());
        medication.setDoseInterval(request.getDoseInterval());
        medication.setActiveIngredients(request.getActiveIngredients());
        medication.setPharmaceuticalForm(request.getPharmaceuticalForm());
        medication.setAdministrationRoute(request.getAdministrationRoute());
        medication.setStartDate(request.getStartDate());
        medication.setEndDate(request.getEndDate());
        medication.setStartTime(request.getStartTime());
        medication.setTreatmentDurationDays(request.getTreatmentDurationDays());
        medication.setUser(targetUser);

        if (request.getEndDate() == null
            && request.getStartDate() != null
            && request.getTreatmentDurationDays() > 0) {
            medication.setEndDate(
                request.getStartDate().plusDays(request.getTreatmentDurationDays()));
        }

        if (request.getStockQuantity() > 0) {
            medication.setStockQuantity(request.getStockQuantity());
            medication.setCurrentStock(request.getStockQuantity());
        }

        if (request.getMedicationImage() != null)
            medication.setMedicationImage(request.getMedicationImage());

        return MedicationResponse.toResponse(medicationRepository.save(medication));
    }

    public List<MedicationResponse> listByUser(Long userId) {
        assertCanAccessUser(userId);
        return medicationRepository
                .findByUserIdAndTreatmentStatusNot(userId, TreatmentStatus.DISCONTINUED)
                .stream()
                .map(MedicationResponse::toResponse)
                .toList();
    }

    public MedicationResponse getById(Long id) {
        Medication medication = medicationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Medicamento não encontrado"));
        assertCanAccessUser(medication.getUser().getId());
        return MedicationResponse.toResponse(medication);
    }

    public MedicationResponse update(Long id, MedicationRequest request) {
        Medication medication = medicationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Medicamento não encontrado"));

        assertCanAccessUser(medication.getUser().getId());

        medication.setName(request.getName());
        medication.setDosage(request.getDosage());
        medication.setDoseInterval(request.getDoseInterval());
        medication.setActiveIngredients(request.getActiveIngredients());
        medication.setPharmaceuticalForm(request.getPharmaceuticalForm());
        medication.setAdministrationRoute(request.getAdministrationRoute());
        medication.setStartDate(request.getStartDate());
        medication.setStartTime(request.getStartTime());
        medication.setMedicationImage(request.getMedicationImage());
        medication.setTreatmentDurationDays(request.getTreatmentDurationDays());

        if (request.getEndDate() != null) {
            medication.setEndDate(request.getEndDate());
        } else if (request.getStartDate() != null && request.getTreatmentDurationDays() > 0) {
            medication.setEndDate(
                request.getStartDate().plusDays(request.getTreatmentDurationDays()));
        }

        if (request.getStockQuantity() > 0) {
            medication.setStockQuantity(request.getStockQuantity());
            medication.setCurrentStock(request.getStockQuantity());
        }

        return MedicationResponse.toResponse(medicationRepository.save(medication));
    }

    public MedicationResponse confirmAcquisition(Long id) {
        Medication medication = medicationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Medicamento não encontrado"));

        assertCanAccessUser(medication.getUser().getId());
        medication.setAcquisitionConfirmed(true);
        return MedicationResponse.toResponse(medicationRepository.save(medication));
    }

    public MedicationResponse endTreatment(Long id) {
        Medication medication = medicationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Medicamento não encontrado"));

        assertCanAccessUser(medication.getUser().getId());
        medication.setTreatmentStatus(TreatmentStatus.COMPLETED);
        medication.setEndDate(LocalDate.now());
        return MedicationResponse.toResponse(medicationRepository.save(medication));
    }

    public void delete(Long id) {
        Medication medication = medicationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Medicamento não encontrado"));

        assertCanAccessUser(medication.getUser().getId());
        medication.setTreatmentStatus(TreatmentStatus.DISCONTINUED);
        medicationRepository.save(medication);
    }

    private void assertCanAccessUser(Long targetUserId) {
        Long currentUserId = getCurrentUserId();
        if (currentUserId == null)
            throw new IllegalArgumentException("Usuário não autenticado");

        if (currentUserId.equals(targetUserId)) return;

        if (userRelationshipRepository.existsByMaster_IdAndMember_Id(
                currentUserId, targetUserId)) return;

        throw new IllegalArgumentException("Acesso negado");
    }

    private Long getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) return null;
        Object principal = auth.getPrincipal();
        if (principal instanceof JwtUsersDetails jwtUser) return jwtUser.getId();
        return null;
    }
}
