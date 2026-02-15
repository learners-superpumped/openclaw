import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';
import '../models/auth_tokens.dart';
import '../models/instance.dart';
import '../models/user.dart';
import 'auth_interceptor.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient(this._storage) {
    _dio = Dio(BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
    _dio.interceptors.add(AuthInterceptor(_dio, _storage));
  }

  // Auth
  Future<AuthTokens> googleLogin(String idToken) async {
    final response = await _dio.post('/auth/google', data: {'idToken': idToken});
    return AuthTokens.fromJson(response.data);
  }

  Future<AuthTokens> appleLogin(String identityToken, {String? givenName, String? familyName}) async {
    final response = await _dio.post('/auth/apple', data: {
      'identityToken': identityToken,
      if (givenName != null) 'givenName': givenName,
      if (familyName != null) 'familyName': familyName,
    });
    return AuthTokens.fromJson(response.data);
  }

  // User
  Future<User> getMe() async {
    final response = await _dio.get('/users/me');
    return User.fromJson(response.data);
  }

  Future<void> deleteAccount() async {
    await _dio.delete('/users/me');
  }

  // Instances
  Future<Instance> createInstance({String? displayName}) async {
    final response = await _dio.post('/instances', data: {
      if (displayName != null) 'displayName': displayName,
    });
    return Instance.fromJson(response.data);
  }

  Future<List<Instance>> listInstances() async {
    final response = await _dio.get('/instances');
    return (response.data as List).map((e) => Instance.fromJson(e)).toList();
  }

  Future<Instance> getInstance(String instanceId) async {
    final response = await _dio.get('/instances/$instanceId');
    return Instance.fromJson(response.data);
  }

  Future<void> deleteInstance(String instanceId) async {
    await _dio.delete('/instances/$instanceId');
  }

  // Telegram
  Future<Map<String, dynamic>> setupTelegram(String instanceId, String botToken, {String? accountId}) async {
    final response = await _dio.post('/instances/$instanceId/telegram/setup', data: {
      'botToken': botToken,
      if (accountId != null) 'accountId': accountId,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> getTelegramStatus(String instanceId, {bool probe = false}) async {
    final response = await _dio.get(
      '/instances/$instanceId/telegram/status',
      queryParameters: probe ? {'probe': 'true'} : null,
    );
    return response.data;
  }

  // Pairing
  Future<List<Map<String, dynamic>>> listPairing(String instanceId, String channel) async {
    final response = await _dio.get(
      '/instances/$instanceId/pairing/list',
      queryParameters: {'channel': channel},
    );
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> approvePairing(String instanceId, String channel, String code) async {
    final response = await _dio.post('/instances/$instanceId/pairing/approve', data: {
      'channel': channel,
      'code': code,
    });
    return response.data;
  }
}
