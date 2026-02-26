import 'package:firebase_analytics/firebase_analytics.dart';

import 'analytics_service.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsService(this._analytics);

  @override
  Future<void> setUserId(String? userId) => _analytics.setUserId(id: userId);

  @override
  Future<void> setUserProperties({String? authProvider, bool? isPro}) async {
    if (authProvider != null) {
      await _analytics.setUserProperty(
        name: 'auth_provider',
        value: authProvider,
      );
    }
    if (isPro != null) {
      await _analytics.setUserProperty(name: 'is_pro', value: isPro.toString());
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
  Future<void> logLogout() => _analytics.logEvent(name: 'logout');

  @override
  Future<void> logAccountDeleted() =>
      _analytics.logEvent(name: 'account_deleted');

  @override
  Future<void> logLoginFailed({
    required String method,
    required String error,
  }) => _analytics.logEvent(
    name: 'login_failed',
    parameters: {'method': method, 'error': _truncate(error)},
  );

  @override
  Future<void> logSignUpFailed({
    required String method,
    required String error,
  }) => _analytics.logEvent(
    name: 'signup_failed',
    parameters: {'method': method, 'error': _truncate(error)},
  );

  // ── Onboarding ──

  @override
  Future<void> logOnboardingStepViewed({required String step}) => _analytics
      .logEvent(name: 'onboarding_step_viewed', parameters: {'step': step});

  @override
  Future<void> logOnboardingComplete() =>
      _analytics.logEvent(name: 'onboarding_complete');

  @override
  Future<void> logAiDisclosureAccepted() =>
      _analytics.logEvent(name: 'ai_disclosure_accepted');

  @override
  Future<void> logTelegramSetupSkipped() =>
      _analytics.logEvent(name: 'telegram_setup_skipped');

  // ── Paywall ──

  @override
  Future<void> logPaywallPurchaseTapped({String? productId}) =>
      _analytics.logEvent(
        name: 'paywall_purchase_tapped',
        parameters: productId != null ? {'product_id': productId} : null,
      );

  @override
  Future<void> logPaywallPurchaseCompleted({String? productId}) =>
      _analytics.logEvent(
        name: 'paywall_purchase_completed',
        parameters: productId != null ? {'product_id': productId} : null,
      );

  @override
  Future<void> logPaywallPurchaseFailed({required String error}) =>
      _analytics.logEvent(
        name: 'paywall_purchase_failed',
        parameters: {'error': _truncate(error)},
      );

  @override
  Future<void> logPaywallRestored() =>
      _analytics.logEvent(name: 'paywall_restored');

  // ── Instance ──

  @override
  Future<void> logInstanceCreationStarted() =>
      _analytics.logEvent(name: 'instance_creation_started');

  @override
  Future<void> logInstanceCreationCompleted() =>
      _analytics.logEvent(name: 'instance_creation_completed');

  @override
  Future<void> logInstanceCreationFailed({required String error}) =>
      _analytics.logEvent(
        name: 'instance_creation_failed',
        parameters: {'error': _truncate(error)},
      );

  // ── Chat ──

  @override
  Future<void> logMessageSent({String? sessionKey}) => _analytics.logEvent(
    name: 'message_sent',
    parameters: sessionKey != null ? {'session_key': sessionKey} : null,
  );

  @override
  Future<void> logSessionCreated() =>
      _analytics.logEvent(name: 'session_created');

  @override
  Future<void> logSessionDeleted() =>
      _analytics.logEvent(name: 'session_deleted');

  @override
  Future<void> logChatModelChanged({required String model}) => _analytics
      .logEvent(name: 'chat_model_changed', parameters: {'model': model});

  @override
  Future<void> logChatFileAttached() =>
      _analytics.logEvent(name: 'chat_file_attached');

  @override
  Future<void> logChatSessionSwitched() =>
      _analytics.logEvent(name: 'chat_session_switched');

  @override
  Future<void> logChatConsentShown() =>
      _analytics.logEvent(name: 'chat_consent_shown');

  @override
  Future<void> logChatConsentAccepted() =>
      _analytics.logEvent(name: 'chat_consent_accepted');

  // ── Dashboard ──

  @override
  Future<void> logDashboardTileTapped({required String tile}) => _analytics
      .logEvent(name: 'dashboard_tile_tapped', parameters: {'tile': tile});

  @override
  Future<void> logBottomNavTapped({required String tab}) =>
      _analytics.logEvent(name: 'bottom_nav_tapped', parameters: {'tab': tab});

  // ── Channel ──

  @override
  Future<void> logChannelConnected({required String channel}) => _analytics
      .logEvent(name: 'channel_connected', parameters: {'channel': channel});

  @override
  Future<void> logChannelDisconnected({required String channel}) => _analytics
      .logEvent(name: 'channel_disconnected', parameters: {'channel': channel});

  @override
  Future<void> logPairingApproved({required String channel}) => _analytics
      .logEvent(name: 'pairing_approved', parameters: {'channel': channel});

  @override
  Future<void> logChannelSetupStarted({required String channel}) =>
      _analytics.logEvent(
        name: 'channel_setup_started',
        parameters: {'channel': channel},
      );

  @override
  Future<void> logChannelPairingStarted({required String channel}) =>
      _analytics.logEvent(
        name: 'channel_pairing_started',
        parameters: {'channel': channel},
      );

  @override
  Future<void> logChannelPairingTimeout({required String channel}) =>
      _analytics.logEvent(
        name: 'channel_pairing_timeout',
        parameters: {'channel': channel},
      );

  @override
  Future<void> logChannelDetailViewed({required String channel}) =>
      _analytics.logEvent(
        name: 'channel_detail_viewed',
        parameters: {'channel': channel},
      );

  // ── Skill ──

  @override
  Future<void> logSkillInstalled({required String slug}) =>
      _analytics.logEvent(name: 'skill_installed', parameters: {'slug': slug});

  @override
  Future<void> logSkillUninstalled({required String slug}) => _analytics
      .logEvent(name: 'skill_uninstalled', parameters: {'slug': slug});

  @override
  Future<void> logSkillDetailViewed({required String slug}) => _analytics
      .logEvent(name: 'skill_detail_viewed', parameters: {'slug': slug});

  @override
  Future<void> logSkillSearchPerformed({required String query}) =>
      _analytics.logEvent(
        name: 'skill_search_performed',
        parameters: {'query': _truncate(query)},
      );

  // ── Settings ──

  @override
  Future<void> logSettingsSubscriptionTapped() =>
      _analytics.logEvent(name: 'settings_subscription_tapped');

  @override
  Future<void> logSettingsAiConsentToggled({required bool enabled}) =>
      _analytics.logEvent(
        name: 'settings_ai_consent_toggled',
        parameters: {'enabled': enabled.toString()},
      );

  // ── Remote View ──

  @override
  Future<void> logRemoteViewOpened() =>
      _analytics.logEvent(name: 'remote_view_opened');

  // ── Error ──

  @override
  Future<void> logErrorOccurred({
    required String screen,
    required String action,
    required String message,
  }) => _analytics.logEvent(
    name: 'error_occurred',
    parameters: {
      'screen': screen,
      'action': action,
      'message': _truncate(message),
    },
  );

  /// Firebase Analytics parameter values are limited to 100 characters.
  String _truncate(String value, [int maxLength = 100]) =>
      value.length <= maxLength ? value : value.substring(0, maxLength);
}
