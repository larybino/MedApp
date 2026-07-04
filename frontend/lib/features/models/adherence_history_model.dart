class AdherenceHistoryModel {
  final String date;
  final int totalDoses;
  final int takenDoses;
  final int missedDoses;
  final int delayedDoses;
  final double adherenceRate;

  AdherenceHistoryModel({
    required this.date,
    required this.totalDoses,
    required this.takenDoses,
    required this.missedDoses,
    required this.delayedDoses,
    required this.adherenceRate,
  });

  factory AdherenceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AdherenceHistoryModel(
      date: json['date'],
      totalDoses: json['totalDoses'],
      takenDoses: json['takenDoses'],
      missedDoses: json['missedDoses'],
      delayedDoses: json['delayedDoses'],
      adherenceRate: (json['adherenceRate'] as num).toDouble(),
    );
  }
}
