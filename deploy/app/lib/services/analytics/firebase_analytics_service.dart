import 'package:firebase_analytics/firebase_analytics.dart';

import 'analytics_service.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsService(this._analytics);

  @override
  Future<void> setUserId(String? userId) =>
      _analytics.setUserId(id: userId);

  @override
  Future<void> setUserProperties({String? authProvider, bool? isPro}) async {
    if (authProvider != null) {
      await _analytics.setUserProperty(
        name: 'auth_provider',
        value: authProvider,
      );
    }
    if (isPro != null) {
      await _analytics.setUserProperty(
        name: 'is_pro',
        value: isPro.toString(),
      );
    }
  }

  // ── Auth ──

  @override
  Future<void> logLogin({required String method}) =>
      _analytics.logLogin(loginMethod: method);

  @override
  Future<void> logSignUp({required String method}) =>
      _analytics.logSignUp(signUpMethod: method);

  @override
  Future<void> logLogout() =>
      _analytics.logEvent(name: 'logout');

  @override
  Future<void> logAccountDeleted() =>
      _analytics.logEvent(name: 'account_deleted');

  // ── Onboarding ──

  @override
  Future<void> logOnboardingComplete() =>
      _analytics.logEvent(name: 'onboarding_complete');

  // ── Chat ──

  @override
  Future<void> logMessageSent({String? sessionKey}) =>
      _analytics.logEvent(
        name: 'message_sent',
        parameters: sessionKey != null ? {'session_key': sessionKey} : null,
      );

  @override
  Future<void> logSessionCreated() =>
      _analytics.logEvent(name: 'session_created');

  @override
  Future<void> logSessionDeleted() =>
      _analytics.logEvent(name: 'session_deleted');

  // ── Channel ──

  @override
  Future<void> logChannelConnected({required String channel}) =>
      _analytics.logEvent(
        name: 'channel_connected',
        parameters: {'channel': channel},
      );

  @override
  Future<void> logChannelDisconnected({required String channel}) =>
      _analytics.logEvent(
        name: 'channel_disconnected',
        parameters: {'channel': channel},
      );

  @override
  Future<void> logPairingApproved({required String channel}) =>
      _analytics.logEvent(
        name: 'pairing_approved',
        parameters: {'channel': channel},
      );

  // ── Skill ──

  @override
  Future<void> logSkillInstalled({required String slug}) =>
      _analytics.logEvent(
        name: 'skill_installed',
        parameters: {'slug': slug},
      );

  @override
  Future<void> logSkillUninstalled({required String slug}) =>
      _analytics.logEvent(
        name: 'skill_uninstalled',
        parameters: {'slug': slug},
      );
}
