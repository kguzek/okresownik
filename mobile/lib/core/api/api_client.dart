import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_exceptions.dart';
import '../constants/app_config.dart';

class ApiClient {
  final http.Client _client;
  final String baseUrl;

  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConfig.tokenKey);
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint')
        .replace(queryParameters: queryParams);

    final response = await _client
        .get(uri, headers: await _headers(withAuth: withAuth))
        .timeout(AppConfig.apiTimeout);

    return _handleResponse(response);
  }

  Future<List<dynamic>> getList(
    String endpoint, {
    Map<String, String>? queryParams,
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint')
        .replace(queryParameters: queryParams);

    final response = await _client
        .get(uri, headers: await _headers(withAuth: withAuth))
        .timeout(AppConfig.apiTimeout);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded;
      }
      throw const ApiException('Expected a list response');
    }

    _throwByStatus(response);
    return [];
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final response = await _client
        .post(
          uri,
          headers: await _headers(withAuth: withAuth),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(AppConfig.apiTimeout);

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final response = await _client
        .put(
          uri,
          headers: await _headers(withAuth: withAuth),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(AppConfig.apiTimeout);

    return _handleResponse(response);
  }

  Future<void> delete(
    String endpoint, {
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final response = await _client
        .delete(uri, headers: await _headers(withAuth: withAuth))
        .timeout(AppConfig.apiTimeout);

    if (response.statusCode != 204 && response.statusCode != 200) {
      _throwByStatus(response);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    }

    _throwByStatus(response);
    return {};
  }

  void _throwByStatus(http.Response response) {
    String message;
    try {
      final body = jsonDecode(response.body);
      message = body['error'] ?? 'Unknown error';
    } catch (_) {
      message = response.body;
    }

    switch (response.statusCode) {
      case 401:
        throw UnauthorizedException(message);
      case 404:
        throw NotFoundException(message);
      case 409:
        throw ConflictException(message);
      default:
        throw ApiException(message, statusCode: response.statusCode);
    }
  }

  void dispose() {
    _client.close();
  }
}
