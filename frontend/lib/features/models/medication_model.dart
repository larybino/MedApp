class MedicationModel {
  final int id;
  final String name;
  final String dosage;
  final String doseInterval;
  final double doseAmount;
  final String doseUnit;

  final String? medicationImage;
  final bool acquisitionConfirmed;

  final String? activeIngredients;
  final String? pharmaceuticalForm;
  final String? administrationRoute;
  final String? startTime;
  final int? stockQuantity;
  final int? currentStock;
  final int userId;

  final int? scheduleId;
  final String? startDate;
  final String? endDate;
  final int? treatmentDurationDays;
  final String? scheduleStatus;

  MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.doseInterval,
    required this.doseAmount,
    required this.doseUnit,
    this.activeIngredients,
    this.pharmaceuticalForm,
    this.administrationRoute,
    this.startTime,
    this.stockQuantity,
    this.currentStock,
    this.acquisitionConfirmed = false,
    this.medicationImage,
    required this.userId,
    this.scheduleId,
    this.startDate,
    this.endDate,
    this.treatmentDurationDays,
    this.scheduleStatus,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      doseInterval: json['doseInterval'],
      doseAmount: (json['doseAmount'] as num?)?.toDouble() ?? 1.0,
      doseUnit: json['doseUnit'] ?? 'unidade',
      activeIngredients: json['activeIngredients'],
      pharmaceuticalForm: json['pharmaceuticalForm'],
      administrationRoute: json['administrationRoute'],
      startDate: json['startDate'],
      startTime: json['startTime'],
      endDate: json['endDate'],
      treatmentDurationDays: json['treatmentDurationDays'],
      stockQuantity: json['stockQuantity'],
      currentStock: json['currentStock'],
      acquisitionConfirmed: json['acquisitionConfirmed'] ?? false,
      medicationImage: json['medicationImage'],
      userId: json['userId'],
      scheduleId: json['scheduleId'],
      scheduleStatus: json['scheduleStatus'],
    );
  }
}
