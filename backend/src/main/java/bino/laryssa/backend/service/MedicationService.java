package bino.laryssa.backend.service;

import java.util.List;
import java.util.stream.Stream;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import bino.laryssa.backend.exception.NotFoundException;
import bino.laryssa.backend.jwt.JwtUsersDetails;
import bino.laryssa.backend.model.Medication;
import bino.laryssa.backend.model.User;
import bino.laryssa.backend.model.dto.MedicationRequest;
import bino.laryssa.backend.model.dto.MedicationResponse;
import bino.laryssa.backend.model.enums.ScheduleStatus;
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
    private final ScheduleService scheduleService;

    public MedicationResponse create(MedicationRequest request) {
        Long currentUserId = getCurrentUserId();

        Long targetUserId = request.getUserId() != null ? request.getUserId(): currentUserId;

        assertCanAccessUser(targetUserId);

        User targetUser = userRepository.findById(targetUserId).orElseThrow(() -> new NotFoundException("Usuário não encontrado"));

        Medication medication = new Medication();
        medication.setName(request.getName());
        medication.setDosage(request.getDosage());
        medication.setDoseInterval(request.getDoseInterval());
        medication.setDoseAmount(request.getDoseAmount());
        medication.setDoseUnit(request.getDoseUnit());
        medication.setActiveIngredients(request.getActiveIngredients());
        medication.setPharmaceuticalForm(request.getPharmaceuticalForm());
        medication.setAdministrationRoute(request.getAdministrationRoute());
        medication.setUser(targetUser);

        if (request.getStockQuantity() > 0) {
            medication.setStockQuantity(request.getStockQuantity());
            medication.setCurrentStock(request.getStockQuantity());
        }

        if (request.getMedicationImage() != null)
            medication.setMedicationImage(request.getMedicationImage());

        Medication saved = medicationRepository.save(medication);

        if (request.getStartDate() != null) {
            scheduleService.create(saved, request);
        }
        return MedicationResponse.toResponse(medicationRepository.save(medication));
    }

    public List<MedicationResponse> listByUser(Long userId) {
        assertCanAccessUser(userId);

        List<Medication> withSchedule = medicationRepository
                .findByUserIdAndSchedule_ScheduleStatusNotAndActiveTrue(userId, ScheduleStatus.CANCELLED);

        List<Medication> withoutSchedule = medicationRepository
                .findByUserIdAndScheduleIsNullAndActiveTrue(userId);

        return Stream.concat(withSchedule.stream(), withoutSchedule.stream())
                .map(MedicationResponse::toResponse)
                .toList();
    }

    public MedicationResponse getById(Long id) {
        Medication medication = medicationRepository.findById(id).orElseThrow(() -> new NotFoundException("Medicamento não encontrado"));
        assertCanAccessUser(medication.getUser().getId());
        return MedicationResponse.toResponse(medication);
    }

    public MedicationResponse update(Long id, MedicationRequest request) {
        Medication medication = medicationRepository.findById(id).orElseThrow(() -> new NotFoundException("Medicamento não encontrado"));

        assertCanAccessUser(medication.getUser().getId());

        medication.setName(request.getName());
        medication.setDosage(request.getDosage());
        medication.setDoseInterval(request.getDoseInterval());
        medication.setDoseAmount(request.getDoseAmount());
        medication.setDoseUnit(request.getDoseUnit());
        medication.setActiveIngredients(request.getActiveIngredients());
        medication.setPharmaceuticalForm(request.getPharmaceuticalForm());
        medication.setAdministrationRoute(request.getAdministrationRoute());
        medication.setStartTime(request.getStartTime());
        medication.setMedicationImage(request.getMedicationImage());
        medication.setAcquisitionConfirmed(request.isAcquisitionConfirmed());

        if (request.getStockQuantity() > 0) {
            medication.setStockQuantity(request.getStockQuantity());
            medication.setCurrentStock(request.getStockQuantity());
        }

        medicationRepository.save(medication);

        if (request.isAcquisitionConfirmed() && medication.getSchedule() == null
            && request.getStartDate() != null && request.getStartTime() != null) {
            scheduleService.create(medication, request);
        } else if (request.getStartDate() != null && medication.getSchedule() != null) {
            scheduleService.update(medication.getSchedule(), request);
        }

        return MedicationResponse.toResponse(medicationRepository.findById(id).orElseThrow());
    }

    public MedicationResponse confirmAcquisition(Long id) {
        Medication medication = medicationRepository.findById(id).orElseThrow(() -> new NotFoundException("Medicamento não encontrado"));

        assertCanAccessUser(medication.getUser().getId());
        medication.setAcquisitionConfirmed(true);
        return MedicationResponse.toResponse(medicationRepository.save(medication));
    }

    public MedicationResponse endTreatment(Long id) {
        Medication medication = medicationRepository.findById(id).orElseThrow(() -> new NotFoundException("Medicamento não encontrado"));
        assertCanAccessUser(medication.getUser().getId());
        if (medication.getSchedule() != null) {
            scheduleService.finish(medication.getSchedule());
        }
        return MedicationResponse.toResponse(medicationRepository.save(medication));
    }

    public void delete(Long id) {
        Medication medication = medicationRepository.findById(id).orElseThrow(() -> new NotFoundException("Medicamento não encontrado"));
        assertCanAccessUser(medication.getUser().getId());
        if (medication.getSchedule() != null) {
            scheduleService.cancel(medication.getSchedule());
        }
        medication.setActive(false);
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
