import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/cycle_repository.dart';
import 'cycle_state.dart';

class CycleCubit extends Cubit<CycleState> {
  final CycleRepository _repository;

  CycleCubit(this._repository) : super(const CycleState());

  Future<void> loadDays({String? from, String? to}) async {
    emit(state.copyWith(status: CycleStatus.loading));

    try {
      final days = await _repository.getDays(from: from, to: to);
      emit(state.copyWith(
        status: CycleStatus.loaded,
        days: days,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CycleStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> loadPrediction() async {
    try {
      final prediction = await _repository.getPrediction();
      emit(state.copyWith(prediction: prediction));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> markPeriodDay({
    required String date,
    bool isPeriod = true,
    String flow = 'light',
  }) async {
    try {
      final existing = state.dayForDate(DateTime.parse(date));
      await _repository.upsertDay(
        date: date,
        isPeriod: isPeriod,
        isIntercourse: existing?.isIntercourse ?? false,
        flow: flow,
        notes: existing?.notes ?? '',
      );
      await loadDays();
      await loadPrediction();
    } catch (e) {
      emit(state.copyWith(
        status: CycleStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> markIntercourseDay({
    required String date,
    bool isIntercourse = true,
  }) async {
    try {
      final existing = state.dayForDate(DateTime.parse(date));
      await _repository.upsertDay(
        date: date,
        isPeriod: existing?.isPeriod ?? false,
        isIntercourse: isIntercourse,
        flow: existing?.flow ?? '',
        notes: existing?.notes ?? '',
      );
      await loadDays();
      await loadPrediction();
    } catch (e) {
      emit(state.copyWith(
        status: CycleStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> clearDay(String date) async {
    try {
      final existing = state.dayForDate(DateTime.parse(date));
      if (existing != null) {
        await _repository.deleteDay(existing.id);
        await loadDays();
        await loadPrediction();
      }
    } catch (e) {
      emit(state.copyWith(
        status: CycleStatus.error,
        error: e.toString(),
      ));
    }
  }

  void selectDay(DateTime date) {
    final day = state.dayForDate(date);
    emit(state.copyWith(selectedDay: day));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
