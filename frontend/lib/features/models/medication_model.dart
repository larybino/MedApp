class MedicationModel {
  final int id;
  final String name;
  final String dosage;
  final String doseInterval;
  final String treatmentStatus;

  final String? medicationImage;
  final bool acquisitionConfirmed;

  final String? activeIngredients;
  final String? pharmaceuticalForm;
  final String? administrationRoute;
  final String? startDate;
  final String? startTime;
  final String? endDate;
  final int? treatmentDurationDays;
  final int? stockQuantity;
  final int? currentStock;
  final int userId;

  MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.doseInterval,
    this.activeIngredients,
    this.pharmaceuticalForm,
    this.administrationRoute,
    this.startDate,
    this.startTime,
    this.endDate,
    this.treatmentDurationDays,
    this.stockQuantity,
    this.currentStock,
    this.acquisitionConfirmed = false,
    this.medicationImage,
    required this.treatmentStatus,
    required this.userId,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      doseInterval: json['doseInterval'],
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
      treatmentStatus: json['treatmentStatus'],
      userId: json['userId'],
    );
  }
}