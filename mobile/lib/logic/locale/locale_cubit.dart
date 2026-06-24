import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_config.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('pl')) {
    Intl.defaultLocale = 'pl';
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(AppConfig.localeKey) ?? 'pl';
    final locale = Locale(code);
    if (code != 'pl') {
      Intl.defaultLocale = code;
    }
    emit(locale);
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.localeKey, locale.languageCode);
    Intl.defaultLocale = locale.languageCode;
    emit(locale);
  }
}
