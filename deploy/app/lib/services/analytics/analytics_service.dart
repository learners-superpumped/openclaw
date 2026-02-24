abstract class AnalyticsService {
  // ── User Identity ──
  Future<void> setUserId(String? userId);
  Future<void> setUserProperties({String? authProvider, bool? isPro});

  // ── Auth ──
  Future<void> logLogin({required String method});
  Future<void> logSignUp({required String method});
  Future<void> logLogout();
  Future<void> logAccountDeleted();

  // ── Onboarding ──
  Future<void> logOnboardingComplete();

  // ── Chat ──
  Future<void> logMessageSent({String? sessionKey});
  Future<void> logSessionCreated();
  Future<void> logSessionDeleted();

  // ── Channel ──
  Future<void> logChannelConnected({required String channel});
  Future<void> logChannelDisconnected({required String channel});
  Future<void> logPairingApproved({required String channel});

  // ── Skill ──
  Future<void> logSkillInstalled({required String slug});
  Future<void> logSkillUninstalled({required String slug});
}
