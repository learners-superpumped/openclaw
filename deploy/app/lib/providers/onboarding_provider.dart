import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'instance_provider.dart';
import 'subscription_provider.dart';

enum OnboardingStep {
  paywall,
  auth,
  instanceLoading,
  telegramSetup,
  telegramPairing,
  dashboard,
}

/// 인스턴스 ready 이후 setup 진행 상태를 추적
final setupProgressProvider = StateProvider<OnboardingStep>((ref) {
  return OnboardingStep.telegramSetup;
});

final onboardingStepProvider = Provider<OnboardingStep>((ref) {
  final isPro = ref.watch(isProProvider);
  final authState = ref.watch(authProvider);
  final instanceState = ref.watch(instanceProvider);
  final setupProgress = ref.watch(setupProgressProvider);

  if (!isPro) return OnboardingStep.paywall;
  if (authState.status != AuthStatus.authenticated) return OnboardingStep.auth;

  switch (instanceState.status) {
    case InstanceStatus.idle:
    case InstanceStatus.creating:
    case InstanceStatus.polling:
    case InstanceStatus.error:
      return OnboardingStep.instanceLoading;
    case InstanceStatus.ready:
      return setupProgress;
  }
});
