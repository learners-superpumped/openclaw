import 'analytics_service.dart';

class CompositeAnalyticsService implements AnalyticsService {
  final List<AnalyticsService> _services;

  CompositeAnalyticsService(this._services);

  @override
  Future<void> setUserId(String? userId) =>
      Future.wait(_services.map((s) => s.setUserId(userId)));

  @override
  Future<void> setUserProperties({String? authProvider, bool? isPro}) =>
      Future.wait(
        _services.map(
          (s) => s.setUserProperties(authProvider: authProvider, isPro: isPro),
        ),
      );

  @override
  Future<void> logLogin({required String method}) =>
      Future.wait(_services.map((s) => s.logLogin(method: method)));

  @override
  Future<void> logSignUp({required String method}) =>
      Future.wait(_services.map((s) => s.logSignUp(method: method)));

  @override
  Future<void> logLogout() => Future.wait(_services.map((s) => s.logLogout()));

  @override
  Future<void> logAccountDeleted() =>
      Future.wait(_services.map((s) => s.logAccountDeleted()));

  @override
  Future<void> logLoginFailed({
    required String method,
    required String error,
  }) => Future.wait(
    _services.map((s) => s.logLoginFailed(method: method, error: error)),
  );

  @override
  Future<void> logSignUpFailed({
    required String method,
    required String error,
  }) => Future.wait(
    _services.map((s) => s.logSignUpFailed(method: method, error: error)),
  );

  @override
  Future<void> logOnboardingStepViewed({required String step}) =>
      Future.wait(_services.map((s) => s.logOnboardingStepViewed(step: step)));

  @override
  Future<void> logOnboardingComplete() =>
      Future.wait(_services.map((s) => s.logOnboardingComplete()));

  @override
  Future<void> logAiDisclosureAccepted() =>
      Future.wait(_services.map((s) => s.logAiDisclosureAccepted()));

  @override
  Future<void> logTelegramSetupSkipped() =>
      Future.wait(_services.map((s) => s.logTelegramSetupSkipped()));

  @override
  Future<void> logPaywallPurchaseTapped({String? productId}) => Future.wait(
    _services.map((s) => s.logPaywallPurchaseTapped(productId: productId)),
  );

  @override
  Future<void> logPaywallPurchaseCompleted({String? productId}) => Future.wait(
    _services.map((s) => s.logPaywallPurchaseCompleted(productId: productId)),
  );

  @override
  Future<void> logPaywallPurchaseFailed({required String error}) => Future.wait(
    _services.map((s) => s.logPaywallPurchaseFailed(error: error)),
  );

  @override
  Future<void> logPaywallRestored() =>
      Future.wait(_services.map((s) => s.logPaywallRestored()));

  @override
  Future<void> logInstanceCreationStarted() =>
      Future.wait(_services.map((s) => s.logInstanceCreationStarted()));

  @override
  Future<void> logInstanceCreationCompleted() =>
      Future.wait(_services.map((s) => s.logInstanceCreationCompleted()));

  @override
  Future<void> logInstanceCreationFailed({required String error}) =>
      Future.wait(
        _services.map((s) => s.logInstanceCreationFailed(error: error)),
      );

  @override
  Future<void> logMessageSent({String? sessionKey}) => Future.wait(
    _services.map((s) => s.logMessageSent(sessionKey: sessionKey)),
  );

  @override
  Future<void> logSessionCreated() =>
      Future.wait(_services.map((s) => s.logSessionCreated()));

  @override
  Future<void> logSessionDeleted() =>
      Future.wait(_services.map((s) => s.logSessionDeleted()));

  @override
  Future<void> logChatModelChanged({required String model}) =>
      Future.wait(_services.map((s) => s.logChatModelChanged(model: model)));

  @override
  Future<void> logChatFileAttached() =>
      Future.wait(_services.map((s) => s.logChatFileAttached()));

  @override
  Future<void> logChatSessionSwitched() =>
      Future.wait(_services.map((s) => s.logChatSessionSwitched()));

  @override
  Future<void> logChatConsentShown() =>
      Future.wait(_services.map((s) => s.logChatConsentShown()));

  @override
  Future<void> logChatConsentAccepted() =>
      Future.wait(_services.map((s) => s.logChatConsentAccepted()));

  @override
  Future<void> logDashboardTileTapped({required String tile}) =>
      Future.wait(_services.map((s) => s.logDashboardTileTapped(tile: tile)));

  @override
  Future<void> logBottomNavTapped({required String tab}) =>
      Future.wait(_services.map((s) => s.logBottomNavTapped(tab: tab)));

  @override
  Future<void> logChannelConnected({required String channel}) => Future.wait(
    _services.map((s) => s.logChannelConnected(channel: channel)),
  );

  @override
  Future<void> logChannelDisconnected({required String channel}) => Future.wait(
    _services.map((s) => s.logChannelDisconnected(channel: channel)),
  );

  @override
  Future<void> logPairingApproved({required String channel}) =>
      Future.wait(_services.map((s) => s.logPairingApproved(channel: channel)));

  @override
  Future<void> logChannelSetupStarted({required String channel}) => Future.wait(
    _services.map((s) => s.logChannelSetupStarted(channel: channel)),
  );

  @override
  Future<void> logChannelPairingStarted({required String channel}) =>
      Future.wait(
        _services.map((s) => s.logChannelPairingStarted(channel: channel)),
      );

  @override
  Future<void> logChannelPairingTimeout({required String channel}) =>
      Future.wait(
        _services.map((s) => s.logChannelPairingTimeout(channel: channel)),
      );

  @override
  Future<void> logChannelDetailViewed({required String channel}) => Future.wait(
    _services.map((s) => s.logChannelDetailViewed(channel: channel)),
  );

  @override
  Future<void> logSkillInstalled({required String slug}) =>
      Future.wait(_services.map((s) => s.logSkillInstalled(slug: slug)));

  @override
  Future<void> logSkillUninstalled({required String slug}) =>
      Future.wait(_services.map((s) => s.logSkillUninstalled(slug: slug)));

  @override
  Future<void> logSkillDetailViewed({required String slug}) =>
      Future.wait(_services.map((s) => s.logSkillDetailViewed(slug: slug)));

  @override
  Future<void> logSkillSearchPerformed({required String query}) => Future.wait(
    _services.map((s) => s.logSkillSearchPerformed(query: query)),
  );

  @override
  Future<void> logSettingsSubscriptionTapped() =>
      Future.wait(_services.map((s) => s.logSettingsSubscriptionTapped()));

  @override
  Future<void> logSettingsAiConsentToggled({required bool enabled}) =>
      Future.wait(
        _services.map((s) => s.logSettingsAiConsentToggled(enabled: enabled)),
      );

  @override
  Future<void> logRemoteViewOpened() =>
      Future.wait(_services.map((s) => s.logRemoteViewOpened()));

  @override
  Future<void> logErrorOccurred({
    required String screen,
    required String action,
    required String message,
  }) => Future.wait(
    _services.map(
      (s) =>
          s.logErrorOccurred(screen: screen, action: action, message: message),
    ),
  );
}
