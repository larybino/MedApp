import 'package:flutter/services.dart';

class AlarmLaunchService {
  static const _channel = MethodChannel('medapp/alarm_launch');

  static Future<int?> consumePendingAlarmId() async {
    try {
      final result = await _channel.invokeMethod<int>('consumeAlarmLaunch');
      return result;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  static Future<bool> canUseFullScreenIntent() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'canUseFullScreenIntent',
      );
      return result ?? true;
    } on PlatformException {
      return true;
    } on MissingPluginException {
      return true;
    }
  }

  static Future<void> openFullScreenIntentSettings() async {
    try {
      await _channel.invokeMethod('openFullScreenIntentSettings');
    } on PlatformException {
      // ignore
    } on MissingPluginException {
      // ignore
    }
  }
}