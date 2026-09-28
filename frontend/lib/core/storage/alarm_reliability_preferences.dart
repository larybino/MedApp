import 'package:shared_preferences/shared_preferences.dart';

class AlarmReliabilityPreferences {
  static const _askedKey = 'alarm_reliability_permission_asked';

  static Future<bool> getAlreadyAsked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_askedKey) ?? false;
  }

  static Future<void> setAlreadyAsked() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_askedKey, true);
  }
}
