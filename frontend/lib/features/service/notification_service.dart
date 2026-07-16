import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/features/models/medication_model.dart';
import 'package:frontend/features/models/schedule_dose_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _confirmationChannelId = 'dose_confirmation';
  static const _stockChannelId = 'stock_alert';

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _confirmationChannelId,
        'Confirmação de dose',
        description: 'Lembrete para confirmar se tomou o remédio',
        importance: Importance.high,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _stockChannelId,
        'Alerta de estoque',
        description: 'Aviso quando o estoque do medicamento está acabando',
        importance: Importance.high,
      ),
    );
  }

  static Future<void> scheduleConfirmationNotification(
    ScheduledDoseModel dose,
  ) async {
    final timeParts = dose.scheduledTime.split(':');
    final dateParts = dose.scheduledDate.split('-');

    final scheduledDateTime = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    final notificationTime = scheduledDateTime.add(const Duration(minutes: 30));
    if (notificationTime.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      dose.id + 100000,
      'Você tomou o remédio?',
      '${dose.medicationName} — ${dose.dosage} estava agendado para as '
          '${timeParts[0]}:${timeParts[1]}',
      tz.TZDateTime.from(notificationTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _confirmationChannelId,
          'Confirmação de dose',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'dose_${dose.id}',
    );
  }

  static Future<void> checkAndNotifyLowStock(MedicationModel medication) async {
    if (medication.currentStock == null) return;

    final doseInterval = _getIntervalHours(medication.doseInterval);
    if (doseInterval == 0) return;

    final dosesPerDay = 24 ~/ doseInterval;
    if (dosesPerDay == 0) return;

    final daysLeft = medication.currentStock! ~/ dosesPerDay;
    if (daysLeft < 5 || daysLeft > 10) return;

    final alreadyNotified = await _wasNotifiedToday(medication.id);
    if (alreadyNotified) return;

    await _plugin.show(
      medication.id + 200000,
      'Estoque baixo — ${medication.name}',
      'Restam aproximadamente $daysLeft dias de estoque. '
          'Lembre-se de repor o medicamento.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _stockChannelId,
          'Alerta de estoque',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );

    await _markNotifiedToday(medication.id);
  }

  static Future<bool> _wasNotifiedToday(int medicationId) async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString('low_stock_notified_$medicationId');
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return lastDate == today;
  }

  static Future<void> _markNotifiedToday(int medicationId) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await prefs.setString('low_stock_notified_$medicationId', today);
  }

  static Future<void> cancelConfirmationNotification(int doseId) async {
    await _plugin.cancel(doseId + 100000);
  }

  static Future<void> scheduleAllConfirmations(
    List<ScheduledDoseModel> doses,
  ) async {
    for (final dose in doses) {
      if (dose.doseStatus == 'PENDING') {
        await scheduleConfirmationNotification(dose);
      }
    }
  }

  static int _getIntervalHours(String doseInterval) {
    switch (doseInterval) {
      case 'FOUR_HOURS':
        return 4;
      case 'SIX_HOURS':
        return 6;
      case 'EIGHT_HOURS':
        return 8;
      case 'TWELVE_HOURS':
        return 12;
      case 'TWENTY_FOUR_HOURS':
        return 24;
      default:
        return 0;
    }
  }
}
