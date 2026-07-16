import 'package:flutter/material.dart';
import 'package:frontend/core/storage/notification_preferences.dart';
import 'package:frontend/features/models/schedule_dose_model.dart';
import 'package:frontend/features/service/alarm_service.dart';
import 'package:frontend/features/service/notification_service.dart';
import '../../../core/storage/secure_storage.dart';
import '../../features/service/schedule_service.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleService _service = ScheduleService();

  List<ScheduledDoseModel> _doses = [];
  bool _isLoading = false;

  List<ScheduledDoseModel> get doses => _doses;
  bool get isLoading => _isLoading;

  List<ScheduledDoseModel> get pendingDoses =>
      _doses.where((d) => d.doseStatus == 'PENDING').toList();

  List<ScheduledDoseModel> get takenDoses =>
      _doses.where((d) => d.doseStatus == 'TAKEN').toList();

  List<ScheduledDoseModel> get missedDoses =>
      _doses.where((d) => d.doseStatus == 'MISSED').toList();

  List<ScheduledDoseModel> get delayedDoses =>
      _doses.where((d) => d.doseStatus == 'DELAYED').toList();

  Future<void> loadTodayDoses({int? userId}) async {
    final targetId = userId ?? await SecureStorage.getUserId();
    if (targetId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _doses = await _service.getTodayDoses(targetId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDosesByDate(String date, {int? userId}) async {
    final targetId = userId ?? await SecureStorage.getUserId();
    if (targetId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _doses = await _service.getDosesByDate(targetId, date);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> confirmDose(int doseId) async {
    await _service.confirmDose(doseId);
    await loadTodayDoses();
  }

  Future<void> syncNotifications({
    required bool isMaster,
    required List<int> memberIds,
  }) async {
    final targetId = await SecureStorage.getUserId();
    if (targetId == null) return;

    final onlyMyDoses = await NotificationPreferences.getOnlyMyDoses();

    final userIdsToNotify = <int>[targetId];
    if (isMaster && !onlyMyDoses) {
      userIdsToNotify.addAll(memberIds);
    }

    final allDoses = <ScheduledDoseModel>[];
    for (final id in userIdsToNotify) {
      allDoses.addAll(await _service.getTodayDoses(id));
    }

    await AlarmService.scheduleAllDoses(allDoses);
    await NotificationService.scheduleAllConfirmations(allDoses);
  }
}
