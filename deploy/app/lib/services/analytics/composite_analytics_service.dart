import 'analytics_service.dart';

class CompositeAnalyticsService implements AnalyticsService {
  final List<AnalyticsService> _services;

  CompositeAnalyticsService(this._services);

  @override
  Future<void> setUserId(String? userId) =>
      Future.wait(_services.map((s) => s.setUserId(userId)));

  @override
  Future<void> setUserProperties({String? authProvider, bool? isPro}) =>
      Future.wait(_services.map(
        (s) => s.setUserProperties(authProvider: authProvider, isPro: isPro),
      ));

  @override
  Future<void> logLogin({required String method}) =>
      Future.wait(_services.map((s) => s.logLogin(method: method)));

  @override
  Future<void> logSignUp({required String method}) =>
      Future.wait(_services.map((s) => s.logSignUp(method: method)));

  @override
  Future<void> logLogout() =>
      Future.wait(_services.map((s) => s.logLogout()));

  @override
  Future<void> logAccountDeleted() =>
      Future.wait(_services.map((s) => s.logAccountDeleted()));

  @override
  Future<void> logOnboardingComplete() =>
      Future.wait(_services.map((s) => s.logOnboardingComplete()));

  @override
  Future<void> logMessageSent({String? sessionKey}) =>
      Future.wait(_services.map((s) => s.logMessageSent(sessionKey: sessionKey)));

  @override
  Future<void> logSessionCreated() =>
      Future.wait(_services.map((s) => s.logSessionCreated()));

  @override
  Future<void> logSessionDeleted() =>
      Future.wait(_services.map((s) => s.logSessionDeleted()));

  @override
  Future<void> logChannelConnected({required String channel}) =>
      Future.wait(_services.map((s) => s.logChannelConnected(channel: channel)));

  @override
  Future<void> logChannelDisconnected({required String channel}) =>
      Future.wait(_services.map((s) => s.logChannelDisconnected(channel: channel)));

  @override
  Future<void> logPairingApproved({required String channel}) =>
      Future.wait(_services.map((s) => s.logPairingApproved(channel: channel)));

  @override
  Future<void> logSkillInstalled({required String slug}) =>
      Future.wait(_services.map((s) => s.logSkillInstalled(slug: slug)));

  @override
  Future<void> logSkillUninstalled({required String slug}) =>
      Future.wait(_services.map((s) => s.logSkillUninstalled(slug: slug)));
}
