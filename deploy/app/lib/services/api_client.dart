import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';
import '../models/ai_model.dart';
import '../models/auth_tokens.dart';
import '../models/instance.dart';
import '../models/skill.dart';
import '../models/usage.dart';
import '../models/user.dart';
import 'auth_interceptor.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.add(AuthInterceptor(_dio, _storage));
  }

  // Auth
  Future<AuthTokens> googleLogin(String idToken) async {
    final response = await _dio.post(
      '/auth/google',
      data: {'idToken': idToken},
    );
    return AuthTokens.fromJson(response.data);
  }

  Future<AuthTokens> appleLogin(
    String identityToken, {
    String? givenName,
    String? familyName,
  }) async {
    final response = await _dio.post(
      '/auth/apple',
      data: {
        'identityToken': identityToken,
        'givenName': ?givenName,
        'familyName': ?familyName,
      },
    );
    return AuthTokens.fromJson(response.data);
  }

  Future<AuthTokens> emailLogin(String email, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return AuthTokens.fromJson(response.data);
  }

  Future<AuthTokens> emailSignup(
    String email,
    String password, {
    String? name,
  }) async {
    final response = await _dio.post(
      '/auth/signup',
      data: {
        'email': email,
        'password': password,
        if (name != null && name.isNotEmpty) 'name': name,
      },
    );
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

  Future<Usage> getUsage() async {
    final response = await _dio.get('/users/me/usage');
    return Usage.fromJson(response.data);
  }

  // Instances
  Future<Instance> createInstance({
    String? displayName,
    Map<String, dynamic>? profile,
  }) async {
    final response = await _dio.post(
      '/instances',
      data: {'displayName': ?displayName, 'profile': ?profile},
    );
    return Instance.fromJson(response.data);
  }

  Future<List<Instance>> listInstances() async {
    final response = await _dio.get('/instances');
    return (response.data as List).map((e) => Instance.fromJson(e)).toList();
  }

  Future<Instance> getInstance(
    String instanceId, {
    List<String>? include,
    bool probe = false,
  }) async {
    final response = await _dio.get(
      '/instances/$instanceId',
      queryParameters: {
        if (include != null && include.isNotEmpty) 'include': include.join(','),
        if (probe) 'probe': 'true',
      },
      options: Options(receiveTimeout: const Duration(seconds: 25)),
    );
    return Instance.fromJson(response.data);
  }

  Future<void> deleteInstance(String instanceId) async {
    await _dio.delete('/instances/$instanceId');
  }

  // Channels (unified)
  Future<Map<String, dynamic>> getAllChannelsStatus(
    String instanceId, {
    bool probe = false,
  }) async {
    final response = await _dio.get(
      '/instances/$instanceId/channels/status',
      queryParameters: probe ? {'probe': 'true'} : null,
      options: Options(receiveTimeout: const Duration(seconds: 25)),
    );
    return response.data;
  }

  // Telegram
  Future<Map<String, dynamic>> setupTelegram(
    String instanceId,
    String botToken, {
    String? accountId,
  }) async {
    final response = await _dio.post(
      '/instances/$instanceId/telegram/setup',
      data: {'botToken': botToken, 'accountId': ?accountId},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getTelegramStatus(
    String instanceId, {
    bool probe = false,
  }) async {
    final response = await _dio.get(
      '/instances/$instanceId/telegram/status',
      queryParameters: probe ? {'probe': 'true'} : null,
    );
    return response.data;
  }

  Future<void> logoutTelegram(String instanceId) async {
    await _dio.post('/instances/$instanceId/telegram/logout');
  }

  // WhatsApp
  Future<Map<String, dynamic>> requestWhatsappQr(String instanceId) async {
    final response = await _dio.post('/instances/$instanceId/whatsapp/qr');
    return response.data;
  }

  Future<Map<String, dynamic>> waitForWhatsappQr(String instanceId) async {
    final response = await _dio.post(
      '/instances/$instanceId/whatsapp/wait',
      options: Options(receiveTimeout: const Duration(seconds: 65)),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getWhatsappStatus(String instanceId) async {
    final response = await _dio.get('/instances/$instanceId/whatsapp/status');
    return response.data;
  }

  // Discord
  Future<Map<String, dynamic>> getDiscordStatus(
    String instanceId, {
    bool probe = false,
  }) async {
    final response = await _dio.get(
      '/instances/$instanceId/discord/status',
      queryParameters: probe ? {'probe': 'true'} : null,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> setupDiscord(
    String instanceId,
    String botToken, {
    String? accountId,
  }) async {
    final response = await _dio.post(
      '/instances/$instanceId/discord/setup',
      data: {'botToken': botToken, 'accountId': ?accountId},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> logoutDiscord(
    String instanceId, {
    String? accountId,
  }) async {
    final response = await _dio.post(
      '/instances/$instanceId/discord/logout',
      data: {'accountId': ?accountId},
    );
    return response.data as Map<String, dynamic>;
  }

  // Referral
  Future<bool> validateReferral(String code) async {
    final response = await _dio.post('/promo/validate', data: {'code': code});
    return response.data['valid'] as bool;
  }

  Future<void> activateReferral(String code) async {
    await _dio.patch('/users/me/promo', data: {'code': code});
  }

  // Pairing
  Future<List<Map<String, dynamic>>> listPairing(
    String instanceId,
    String channel,
  ) async {
    final response = await _dio.get(
      '/instances/$instanceId/pairing/list',
      queryParameters: {'channel': channel},
    );
    final data = response.data as Map<String, dynamic>;
    return (data['requests'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> approvePairing(
    String instanceId,
    String channel,
    String code,
  ) async {
    final response = await _dio.post(
      '/instances/$instanceId/pairing/approve',
      data: {'channel': channel, 'code': code},
    );
    return response.data;
  }

  // Generic RPC proxy
  Future<Map<String, dynamic>> instanceRpc(
    String instanceId,
    String method, [
    Map<String, dynamic>? params,
  ]) async {
    final response = await _dio.post(
      '/instances/$instanceId/rpc',
      data: {'method': method, 'params': ?params},
      options: Options(receiveTimeout: const Duration(seconds: 30)),
    );
    return response.data as Map<String, dynamic>;
  }

  // Models
  Future<List<AiModel>> listModels() async {
    final response = await _dio.get('/models');
    final data = response.data as Map<String, dynamic>;
    final models = data['models'] as List<dynamic>;
    return models
        .map((e) => AiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ClawHub
  Future<BrowseSkillsResponse> browseSkills(
    String instanceId, {
    String? q,
    int? limit,
    String? cursor,
  }) async {
    final response = await _dio.get(
      '/clawhub/instances/$instanceId/browse',
      queryParameters: {
        if (q != null && q.isNotEmpty) 'q': q,
        'limit': ?limit,
        'cursor': ?cursor,
      },
    );
    return BrowseSkillsResponse.fromJson(response.data);
  }

  Future<BrowseSkillDetail> browseSkillDetail(
    String instanceId,
    String slug,
  ) async {
    final response = await _dio.get(
      '/clawhub/instances/$instanceId/browse/$slug',
    );
    return BrowseSkillDetail.fromJson(response.data);
  }

  Future<Map<String, dynamic>> installSkill(
    String instanceId,
    String slug, {
    String? version,
  }) async {
    final response = await _dio.post(
      '/clawhub/instances/$instanceId/skills',
      data: {'slug': slug, 'version': ?version},
      options: Options(receiveTimeout: const Duration(seconds: 120)),
    );
    return response.data;
  }

  Future<List<Map<String, dynamic>>> getInstalledSkills(
    String instanceId,
  ) async {
    final response = await _dio.get('/clawhub/instances/$instanceId/skills');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> uninstallSkill(
    String instanceId,
    String slug,
  ) async {
    final response = await _dio.delete(
      '/clawhub/instances/$instanceId/skills/$slug',
      options: Options(receiveTimeout: const Duration(seconds: 60)),
    );
    return response.data;
  }
}
