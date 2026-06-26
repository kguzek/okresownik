import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/constants/app_config.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _api;

  AuthRepository(this._api);

  Future<({UserModel user, String token})> register({
    required String email,
    required String password,
    required String name,
    bool termsAccepted = false,
    bool privacyAccepted = false,
    bool consentGranted = false,
  }) async {
    final response = await _api.post(
      ApiEndpoints.register,
      body: {
        'email': email,
        'password': password,
        'name': name,
        'termsAccepted': termsAccepted,
        'privacyAccepted': privacyAccepted,
        'consentGranted': consentGranted,
      },
      withAuth: false,
    );

    final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
    final token = response['token'] as String;

    await _saveToken(token);
    await _saveUser(user);

    return (user: user, token: token);
  }

  Future<({UserModel user, String token})> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      ApiEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
      withAuth: false,
    );

    final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
    final token = response['token'] as String;

    await _saveToken(token);
    await _saveUser(user);

    return (user: user, token: token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.tokenKey);
    await prefs.remove(AppConfig.userDataKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConfig.tokenKey) != null;
  }

  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(AppConfig.userDataKey);
    if (userData == null) return null;
    try {
      final json = jsonDecode(userData) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.tokenKey, token);
  }

  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.userDataKey, jsonEncode(user.toJson()));
  }

  Future<void> updateSavedUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.userDataKey, jsonEncode(user.toJson()));
  }

  Future<void> acceptTerms() async {
    await _api.post(ApiEndpoints.acceptTerms, body: {});
  }

  Future<void> deleteData() async {
    await _api.post(ApiEndpoints.deleteData, body: {});
  }

  Future<void> deleteAccount() async {
    await _api.post(ApiEndpoints.deleteAccount, body: {});
  }
}
