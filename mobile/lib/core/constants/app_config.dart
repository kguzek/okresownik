import 'package:flutter/foundation.dart' show kDebugMode;

class AppConfig {
  AppConfig._();

  static const String _defaultApiBaseUrl = kDebugMode
      ? 'http://localhost:6080'
      : 'https://api.okresownik.pl';

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultApiBaseUrl,
  );

  static const Duration apiTimeout = Duration(seconds: 30);

  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
}
