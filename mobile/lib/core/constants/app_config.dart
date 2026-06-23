class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:6080',
  );

  static const Duration apiTimeout = Duration(seconds: 30);

  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
}
