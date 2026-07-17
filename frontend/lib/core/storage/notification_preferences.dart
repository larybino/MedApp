import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferences {
  static const _onlyMyDosesKey = 'notify_only_my_doses';
  static const _enabledKey = 'notifications_enabled';

  static Future<bool> getOnlyMyDoses() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onlyMyDosesKey) ?? true;
  }

  static Future<void> setOnlyMyDoses(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onlyMyDosesKey, value);
  }

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? true;
  }

  static Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, value);
  }
}
