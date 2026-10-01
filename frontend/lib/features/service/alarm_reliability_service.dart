import 'package:permission_handler/permission_handler.dart';
import 'package:frontend/core/storage/alarm_reliability_preferences.dart';
import 'package:frontend/features/service/alarm_launch_service.dart';

class AlarmReliabilityService {
  static Future<void> requestBasicPermissions() async {
    await Permission.notification.request();
    await Permission.systemAlertWindow.request();

    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  static Future<void> requestOnFirstLaunch() async {
    final alreadyAsked = await AlarmReliabilityPreferences.getAlreadyAsked();
    if (alreadyAsked) return;

    await requestNow();
    await AlarmReliabilityPreferences.setAlreadyAsked();
  }

  static Future<void> requestNow() async {
    await requestBasicPermissions();

    final canUseFullScreenIntent =
        await AlarmLaunchService.canUseFullScreenIntent();
    if (!canUseFullScreenIntent) {
      await AlarmLaunchService.openFullScreenIntentSettings();
    }
  }
}