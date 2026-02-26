abstract class AnalyticsService {
  // ── User Identity ──
  Future<void> setUserId(String? userId);
  Future<void> setUserProperties({String? authProvider, bool? isPro});

  // ── Auth ──
  Future<void> logLogin({required String method});
  Future<void> logSignUp({required String method});
  Future<void> logLogout();
  Future<void> logAccountDeleted();
  Future<void> logLoginFailed({required String method, required String error});
  Future<void> logSignUpFailed({required String method, required String error});

  // ── Onboarding ──
  Future<void> logOnboardingStepViewed({required String step});
  Future<void> logOnboardingComplete();
  Future<void> logAiDisclosureAccepted();
  Future<void> logTelegramSetupSkipped();

  // ── Paywall ──
  Future<void> logPaywallPurchaseTapped({String? productId});
  Future<void> logPaywallPurchaseCompleted({String? productId});
  Future<void> logPaywallPurchaseFailed({required String error});
  Future<void> logPaywallRestored();

  // ── Instance ──
  Future<void> logInstanceCreationStarted();
  Future<void> logInstanceCreationCompleted();
  Future<void> logInstanceCreationFailed({required String error});

  // ── Chat ──
  Future<void> logMessageSent({String? sessionKey});
  Future<void> logSessionCreated();
  Future<void> logSessionDeleted();
  Future<void> logChatModelChanged({required String model});
  Future<void> logChatFileAttached();
  Future<void> logChatSessionSwitched();
  Future<void> logChatConsentShown();
  Future<void> logChatConsentAccepted();

  // ── Dashboard ──
  Future<void> logDashboardTileTapped({required String tile});
  Future<void> logBottomNavTapped({required String tab});

  // ── Channel ──
  Future<void> logChannelConnected({required String channel});
  Future<void> logChannelDisconnected({required String channel});
  Future<void> logPairingApproved({required String channel});
  Future<void> logChannelSetupStarted({required String channel});
  Future<void> logChannelPairingStarted({required String channel});
  Future<void> logChannelPairingTimeout({required String channel});
  Future<void> logChannelDetailViewed({required String channel});

  // ── Skill ──
  Future<void> logSkillInstalled({required String slug});
  Future<void> logSkillUninstalled({required String slug});
  Future<void> logSkillDetailViewed({required String slug});
  Future<void> logSkillSearchPerformed({required String query});

  // ── Settings ──
  Future<void> logSettingsSubscriptionTapped();
  Future<void> logSettingsAiConsentToggled({required bool enabled});

  // ── Remote View ──
  Future<void> logRemoteViewOpened();

  // ── Error ──
  Future<void> logErrorOccurred({
    required String screen,
    required String action,
    required String message,
  });
}
