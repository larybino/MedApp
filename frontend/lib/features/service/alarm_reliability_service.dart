import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:frontend/core/storage/alarm_reliability_preferences.dart';
import 'package:frontend/features/service/alarm_launch_service.dart';


class AlarmReliabilityService {

  static Future<void> requestOnFirstLaunch() async {
    final alreadyAsked = await AlarmReliabilityPreferences.getAlreadyAsked();
    if (alreadyAsked) return;

    await requestNow();
    await AlarmReliabilityPreferences.setAlreadyAsked();
  }

  static Future<void> requestNow() async {
    try {
      final autoStartAvailable = await isAutoStartAvailable ?? false;
      if (autoStartAvailable) {
        await getAutoStartPermission();
      }

      final batteryOptimizationDisabled =
          await isBatteryOptimizationDisabled ?? true;
      if (!batteryOptimizationDisabled) {
        await disableBatteryOptimization();
      }
    } catch (_) {
    }

    final canUseFullScreenIntent =
        await AlarmLaunchService.canUseFullScreenIntent();
    if (!canUseFullScreenIntent) {
      await AlarmLaunchService.openFullScreenIntentSettings();
    }
  }
}