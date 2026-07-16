class ExtractedMedicationModel {
  final String? name;
  final String? dosage;
  final String? doseIntervalText;
  final String? doseInterval;
  final bool requiresManualInterval;
  final bool requiresManualDosage;
  final String? activeIngredients;
  final String? pharmaceuticalForm;
  final String? administrationRoute;
  final double? doseAmount;
  final String? doseUnit;
  final String? treatmentDurationDaysText;

  ExtractedMedicationModel({
    this.name,
    this.dosage,
    this.doseIntervalText,
    this.doseInterval,
    required this.requiresManualInterval,
    required this.requiresManualDosage,
    this.activeIngredients,
    this.pharmaceuticalForm,
    this.administrationRoute,
    this.doseAmount,
    this.doseUnit,
    this.treatmentDurationDaysText,
  });

  factory ExtractedMedicationModel.fromJson(Map<String, dynamic> json) {
    return ExtractedMedicationModel(
      name: json['name'],
      dosage: json['dosage'],
      doseIntervalText: json['doseIntervalText'],
      doseInterval: json['doseInterval'],
      requiresManualInterval: json['requiresManualInterval'] ?? true,
      requiresManualDosage: json['requiresManualDosage'] ?? true,
      activeIngredients: json['activeIngredients'],
      pharmaceuticalForm: json['pharmaceuticalForm'],
      administrationRoute: json['administrationRoute'],
      doseAmount: (json['doseAmount'] as num?)?.toDouble(),
      doseUnit: json['doseUnit'],
      treatmentDurationDaysText: json['treatmentDurationDaysText'],
    );
  }

  int? get parsedTreatmentDurationDays {
    if (treatmentDurationDaysText == null) return null;
    final match = RegExp(r'(\d+)').firstMatch(treatmentDurationDaysText!);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }
}
