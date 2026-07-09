import 'package:flutter/material.dart';
import 'package:frontend/features/models/medication_model.dart';
import 'package:frontend/features/service/medication_service.dart';
import 'package:frontend/features/service/notification_service.dart';
import '../../../core/storage/secure_storage.dart';

class MedicationProvider extends ChangeNotifier {
  final MedicationService _service = MedicationService();

  List<MedicationModel> _medications = [];
  bool _isLoading = false;

  List<MedicationModel> get medications => _medications;
  bool get isLoading => _isLoading;

  List<MedicationModel> get activeMedications =>
      _medications.where((m) => m.scheduleStatus == 'ACTIVE').toList();

  Future<void> loadMedications({int? userId}) async {
    final targetId = userId ?? await SecureStorage.getUserId();
    if (targetId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _medications = await _service.getMedications(targetId);
      for (final med in _medications) {
        await NotificationService.checkAndNotifyLowStock(med);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createMedication(Map<String, dynamic> data) async {
    await _service.create(data);
    await loadMedications();
  }

  Future<void> updateMedication(int id, Map<String, dynamic> data) async {
    final existing = await _service.getById(id);
    final payload = <String, dynamic>{
      'name': existing.name,
      'dosage': existing.dosage,
      'doseInterval': existing.doseInterval,
      'scheduleStatus': existing.scheduleStatus,
      'medicationImage': existing.medicationImage,
      'activeIngredients': existing.activeIngredients,
      'administrationRoute': existing.administrationRoute,
      'pharmaceuticalForm': existing.pharmaceuticalForm,
      'startDate': existing.startDate,
      'endDate': existing.endDate,
      'startTime': existing.startTime,
      'treatmentDurationDays': existing.treatmentDurationDays ?? 0,
      'stockQuantity': existing.stockQuantity ?? 0,
      'userId': existing.userId,
    };

    payload.addAll(_normalizeMedicationPayload(data));

    await _service.update(id, payload);
    await loadMedications();
  }

  Future<void> deleteMedication(int id) async {
    await _service.delete(id);
    await loadMedications();
  }

  Future<void> confirmAcquisition(int id) async {
    await _service.confirmAcquisition(id);
    await loadMedications();
  }

  Future<void> endTreatment(int id) async {
    await _service.endTreatment(id);
    await loadMedications();
  }

  Map<String, dynamic> _normalizeMedicationPayload(Map<String, dynamic> data) {
    final normalized = <String, dynamic>{};

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        normalized[key] = value;
      }
    }

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      switch (key) {
        case 'activeIngredient':
          addIfNotNull('activeIngredients', value);
          break;
        case 'medicationPhoto':
          addIfNotNull('medicationImage', value);
          break;
        case 'targetUserId':
          addIfNotNull('userId', value);
          break;
        default:
          addIfNotNull(key, value);
      }
    }

    return normalized;
  }
}
