import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/routing/navigator_key.dart';
import 'package:frontend/features/alarm/screen/alarm_screen.dart';

class AlarmNavigator {
  static DateTime? _lastShownAt;
  static int? _lastShownId;

  static void showAlarmScreen(AlarmSettings alarm) {
    final now = DateTime.now();
    if (_lastShownId == alarm.id &&
        _lastShownAt != null &&
        now.difference(_lastShownAt!) < const Duration(seconds: 5)) {
      return;
    }
    _lastShownId = alarm.id;
    _lastShownAt = now;

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AlarmScreen(alarmSettings: alarm),
      ),
    );
  }
}
