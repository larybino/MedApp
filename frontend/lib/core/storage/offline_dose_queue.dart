import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/service/schedule_service.dart';

class OfflineDoseQueue {
  static const _key = 'offline_confirmed_doses';
  static bool _isSyncing = false;

  static Future<void> enqueue(int doseId) async {
    final preferences = await SharedPreferences.getInstance();
    final ids = _readIds(preferences);
    if (!ids.contains(doseId)) {
      ids.add(doseId);
      await preferences.setString(_key, jsonEncode(ids));
    }
  }

  static Future<void> remove(int doseId) async {
    final preferences = await SharedPreferences.getInstance();
    final ids = _readIds(preferences)..remove(doseId);
    await preferences.setString(_key, jsonEncode(ids));
  }

  static Future<int> sync() async {
    if (_isSyncing) return 0;
    _isSyncing = true;

    try {
      final preferences = await SharedPreferences.getInstance();
      final ids = _readIds(preferences);
      if (ids.isEmpty) return 0;

      final service = ScheduleService();
      var synced = 0;
      for (final doseId in List<int>.from(ids)) {
        try {
          await service.confirmDose(doseId);
          ids.remove(doseId);
          synced++;
          await preferences.setString(_key, jsonEncode(ids));
        } catch (_) {
          break;
        }
      }
      return synced;
    } finally {
      _isSyncing = false;
    }
  }

  static List<int> _readIds(SharedPreferences preferences) {
    final raw = preferences.getString(_key);
    if (raw == null) return [];

    try {
      return (jsonDecode(raw) as List)
          .map((value) => value is int ? value : int.parse(value.toString()))
          .toSet()
          .toList();
    } catch (_) {
      return [];
    }
  }
}