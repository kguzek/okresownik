import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_config.dart';

class CalendarSettingsCubit extends Cubit<int> {
  CalendarSettingsCubit() : super(DateTime.monday) {
    _loadFirstWeekday();
  }

  Future<void> _loadFirstWeekday() async {
    final prefs = await SharedPreferences.getInstance();
    final weekday = prefs.getInt(AppConfig.firstWeekdayKey) ?? DateTime.monday;
    emit(_normalizeWeekday(weekday));
  }

  Future<void> setFirstWeekday(int weekday) async {
    final normalized = _normalizeWeekday(weekday);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConfig.firstWeekdayKey, normalized);
    emit(normalized);
  }

  int _normalizeWeekday(int weekday) {
    if (weekday < DateTime.monday || weekday > DateTime.sunday) {
      return DateTime.monday;
    }
    return weekday;
  }
}
