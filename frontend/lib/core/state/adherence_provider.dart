import 'package:flutter/material.dart';
import '../../../core/storage/secure_storage.dart';
import '../../features/models/adherence_history_model.dart';
import '../../features/service/adherence_service.dart';

class AdherenceProvider extends ChangeNotifier {
  final AdherenceService _service = AdherenceService();

  List<AdherenceHistoryModel> _history = [];
  bool _isLoading = false;

  List<AdherenceHistoryModel> get history => _history;
  bool get isLoading => _isLoading;

  double get averageAdherenceRate {
    if (_history.isEmpty) return 0;
    final total = _history.fold(0.0, (sum, h) => sum + h.adherenceRate);
    return total / _history.length;
  }

  int get totalTaken => _history.fold(0, (sum, h) => sum + h.takenDoses);

  int get totalMissed => _history.fold(0, (sum, h) => sum + h.missedDoses);

  int get totalDelayed => _history.fold(0, (sum, h) => sum + h.delayedDoses);

  Future<void> loadLast30Days({int? userId}) async {
    final targetId = userId ?? await SecureStorage.getUserId();
    if (targetId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _history = await _service.getLast30Days(targetId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadByPeriod(
    String startDate,
    String endDate, {
    int? userId,
  }) async {
    final targetId = userId ?? await SecureStorage.getUserId();
    if (targetId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _history = await _service.getByPeriod(targetId, startDate, endDate);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
