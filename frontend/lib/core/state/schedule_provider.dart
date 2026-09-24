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
  int? _currentUserId;

  List<ScheduledDoseModel> get doses => _doses;
  bool get isLoading => _isLoading;

  int? get currentUserId => _currentUserId;

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
      _currentUserId = targetId;
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
      _currentUserId = targetId;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> confirmDose(int doseId, {int? userId, String? date}) async {
    await _service.confirmDose(doseId);
    await AlarmService.cancelAlarm(doseId);
    await NotificationService.cancelConfirmationNotification(doseId);
    if (date != null) {
      await loadDosesByDate(date, userId: userId);
      return;
    }
    await loadTodayDoses(userId: userId);
  }

  Future<void> unconfirmDose(int doseId, {int? userId, String? date}) async {
    await _service.unconfirmDose(doseId);
    if (date != null) {
      await loadDosesByDate(date, userId: userId);
      return;
    }
    await loadTodayDoses(userId: userId);
  }

  static const int _alarmSyncWindowDays = 30;

  static String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> syncNotifications({
    required bool isMaster,
    required List<int> memberIds,
  }) async {
    final enabled = await NotificationPreferences.getNotificationsEnabled();
    if (!enabled) {
      await NotificationService.cancelAll();
      await AlarmService.cancelAllAlarms();
      return;
    }

    final targetId = await SecureStorage.getUserId();
    if (targetId == null) return;

    final onlyMyDoses = await NotificationPreferences.getOnlyMyDoses();

    final userIdsToNotify = <int>[targetId];
    if (isMaster && !onlyMyDoses) {
      userIdsToNotify.addAll(memberIds);
    }

    final today = DateTime.now();
    final horizon = today.add(const Duration(days: _alarmSyncWindowDays));

    final allDoses = <ScheduledDoseModel>[];
    for (final id in userIdsToNotify) {
      allDoses.addAll(
        await _service.getDosesInRange(
          id,
          _formatDate(today),
          _formatDate(horizon),
        ),
      );
    }

    await AlarmService.scheduleAllDoses(allDoses);
    await NotificationService.scheduleAllConfirmations(allDoses);
  }
}