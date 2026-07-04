class ScheduledDoseModel {
  final int id;
  final int scheduleId;
  final int medicationId;
  final String medicationName;
  final String dosage;
  final String? medicationImage;
  final String scheduledDate;
  final String scheduledTime;
  final String? confirmedAt;
  final int confirmationWindowMinutes;
  final String doseStatus;
  final bool withinWindow;
  final String patientName;

  ScheduledDoseModel({
    required this.id,
    required this.scheduleId,
    required this.medicationId,
    required this.medicationName,
    required this.dosage,
    this.medicationImage,
    required this.scheduledDate,
    required this.scheduledTime,
    this.confirmedAt,
    required this.confirmationWindowMinutes,
    required this.doseStatus,
    required this.withinWindow,
    required this.patientName,
  });

  factory ScheduledDoseModel.fromJson(Map<String, dynamic> json) {
    return ScheduledDoseModel(
      id: json['id'],
      scheduleId: json['scheduleId'],
      medicationId: json['medicationId'],
      medicationName: json['medicationName'],
      dosage: json['dosage'],
      medicationImage: json['medicationImage'],
      scheduledDate: json['scheduledDate'],
      scheduledTime: json['scheduledTime'],
      confirmedAt: json['confirmedAt'],
      confirmationWindowMinutes: json['confirmationWindowMinutes'],
      doseStatus: json['doseStatus'],
      withinWindow: json['withinWindow'] ?? false,
      patientName: json['patientName'],
    );
  }
}