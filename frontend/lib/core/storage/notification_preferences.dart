import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferences {
  static const _key = 'notify_only_my_doses';

  static Future<bool> getOnlyMyDoses() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true;
  }

  static Future<void> setOnlyMyDoses(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
