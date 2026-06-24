class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.okresownik.pl',
  );

  static const Duration apiTimeout = Duration(seconds: 30);

  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String localeKey = 'app_locale';
}
