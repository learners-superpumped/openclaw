import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  bool _isRefreshing = false;

  AuthInterceptor(this._dio, this._storage);

  bool _isAuthPath(String path) {
    return path.startsWith('/auth/');
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isAuthPath(options.path)) {
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
        _maybeRefreshToken(accessToken);
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isRetry = err.requestOptions.extra['_retried'] == true;

    if (err.response?.statusCode == 401 &&
        !_isRefreshing &&
        !isRetry &&
        !_isAuthPath(err.requestOptions.path)) {
      try {
        await _performRefresh();
        final newAccessToken = await _storage.read(key: 'access_token');
        if (newAccessToken != null) {
          final retryOptions = err.requestOptions;
          retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          retryOptions.extra['_retried'] = true;
          final retryResponse = await _dio.fetch(retryOptions);
          handler.resolve(retryResponse);
          return;
        }
      } catch (_) {
        // refresh failed — fall through
      }
      await _clearTokens();
      handler.next(err);
    } else {
      handler.next(err);
    }
  }

  void _maybeRefreshToken(String token) {
    if (_isRefreshing) return;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return;
      final payload =
          json.decode(
                utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
              )
              as Map<String, dynamic>;
      final exp = payload['exp'] as int?;
      final iat = payload['iat'] as int?;
      if (exp == null || iat == null) return;

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final lifetime = exp - iat;
      final elapsed = now - iat;

      if (elapsed > lifetime * 2 / 3) {
        _performRefresh().catchError((_) {});
      }
    } catch (_) {
      // decoding failure — delegate to 401 fallback
    }
  }

  Future<void> _performRefresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) {
        await _clearTokens();
        return;
      }

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(headers: {}),
      );

      final newAccessToken = response.data['accessToken'] as String;
      final newRefreshToken = response.data['refreshToken'] as String;
      await _storage.write(key: 'access_token', value: newAccessToken);
      await _storage.write(key: 'refresh_token', value: newRefreshToken);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}
