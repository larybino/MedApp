import 'package:alarm/alarm.dart';
import 'package:frontend/features/models/schedule_dose_model.dart';

class AlarmService {

  static Future<void> initialize() async {
    await Alarm.init();
  }

  static Future<void> scheduleAlarm(ScheduledDoseModel dose) async {
    final timeParts = dose.scheduledTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final dateParts = dose.scheduledDate.split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    final scheduledDateTime = DateTime(year, month, day, hour, minute);

    if (scheduledDateTime.isBefore(DateTime.now())) return;

    final alarmSettings = AlarmSettings(
      id: dose.id, 
      dateTime: scheduledDateTime,
      assetAudioPath: 'assets/audio/alarm.mp3',
      loopAudio: true,       
      vibrate: true,
      warningNotificationOnKill: true,
      androidFullScreenIntent: true,
      volumeSettings: const VolumeSettings.fixed(
        volume: 1.0,
        volumeEnforced: true,
      ),
      
      notificationSettings: NotificationSettings(
        title: 'Hora do remédio, ${dose.patientName}!',
        body: '${dose.medicationName} — ${dose.dosage}',
        stopButton: 'Parar alarme',
        icon: 'notification_icon', 
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }

  static Future<void> cancelAlarm(int doseId) async {
    await Alarm.stop(doseId);
  }

  static Future<void> cancelAllAlarms() async {
    await Alarm.stopAll();
  }

  static Future<void> scheduleAllDoses(
      List<ScheduledDoseModel> doses) async {
    await cancelAllAlarms();

    for (final dose in doses) {
      if (dose.doseStatus == 'PENDING') {
        await scheduleAlarm(dose);
      }
    }
  }
}