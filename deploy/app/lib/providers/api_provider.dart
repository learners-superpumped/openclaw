import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/analytics/analytics_service.dart';
import '../services/analytics/composite_analytics_service.dart';
import '../services/analytics/firebase_analytics_service.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(storage);
});

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthService(apiClient, storage);
});

final analyticsProvider = Provider<AnalyticsService>((ref) {
  return CompositeAnalyticsService([
    FirebaseAnalyticsService(FirebaseAnalytics.instance),
  ]);
});
