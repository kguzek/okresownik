class PredictionModel {
  final DateTime nextPeriodStart;
  final DateTime nextPeriodEnd;
  final DateTime ovulationDate;
  final DateTime fertileWindowStart;
  final DateTime fertileWindowEnd;
  final double averageCycleLength;
  final double averagePeriodDuration;
  final int cycleDay;
  final String confidence;

  const PredictionModel({
    required this.nextPeriodStart,
    required this.nextPeriodEnd,
    required this.ovulationDate,
    required this.fertileWindowStart,
    required this.fertileWindowEnd,
    required this.averageCycleLength,
    required this.averagePeriodDuration,
    required this.cycleDay,
    required this.confidence,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String key) {
      final value = json[key];
      if (value == null) return DateTime.now();
      return DateTime.parse(value as String);
    }

    return PredictionModel(
      nextPeriodStart: parseDate('nextPeriodStart'),
      nextPeriodEnd: parseDate('nextPeriodEnd'),
      ovulationDate: parseDate('ovulationDate'),
      fertileWindowStart: parseDate('fertileWindowStart'),
      fertileWindowEnd: parseDate('fertileWindowEnd'),
      averageCycleLength: (json['averageCycleLength'] as num).toDouble(),
      averagePeriodDuration: (json['averagePeriodDuration'] as num).toDouble(),
      cycleDay: json['cycleDay'] as int,
      confidence: json['confidence'] as String? ?? 'very_low',
    );
  }

  bool get hasHighConfidence => confidence == 'high';
  bool get hasMediumConfidence => confidence == 'medium';

  bool isPeriodDay(DateTime date) {
    final d = date.toIso8601String().substring(0, 10);
    final start = nextPeriodStart.toIso8601String().substring(0, 10);
    final end = nextPeriodEnd.toIso8601String().substring(0, 10);
    return d.compareTo(start) >= 0 && d.compareTo(end) <= 0;
  }

  bool isFertileDay(DateTime date) {
    final d = date.toIso8601String().substring(0, 10);
    final start = fertileWindowStart.toIso8601String().substring(0, 10);
    final end = fertileWindowEnd.toIso8601String().substring(0, 10);
    return d.compareTo(start) >= 0 && d.compareTo(end) <= 0;
  }

  bool isOvulationDay(DateTime date) {
    final d = date.toIso8601String().substring(0, 10);
    final o = ovulationDate.toIso8601String().substring(0, 10);
    return d == o;
  }
}
