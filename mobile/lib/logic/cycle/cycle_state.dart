import 'package:equatable/equatable.dart';

import '../../data/models/cycle_day_model.dart';
import '../../data/models/prediction_model.dart';

enum CycleStatus { initial, loading, loaded, error }

class CycleState extends Equatable {
  final CycleStatus status;
  final List<CycleDayModel> days;
  final PredictionModel? prediction;
  final CycleDayModel? selectedDay;
  final String? error;

  const CycleState({
    this.status = CycleStatus.initial,
    this.days = const [],
    this.prediction,
    this.selectedDay,
    this.error,
  });

  CycleState copyWith({
    CycleStatus? status,
    List<CycleDayModel>? days,
    PredictionModel? prediction,
    CycleDayModel? selectedDay,
    String? error,
    bool clearSelected = false,
  }) {
    return CycleState(
      status: status ?? this.status,
      days: days ?? this.days,
      prediction: prediction ?? this.prediction,
      selectedDay: clearSelected ? null : (selectedDay ?? this.selectedDay),
      error: error,
    );
  }

  CycleDayModel? dayForDate(DateTime date) {
    final dateStr = date.toIso8601String().substring(0, 10);
    try {
      return days.firstWhere((d) => d.date == dateStr);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [status, days, prediction, selectedDay, error];
}
