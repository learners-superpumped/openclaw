import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'instance_provider.dart';
import 'subscription_provider.dart';

enum OnboardingStep {
  initializing,
  paywall,
  auth,
  aiDisclosure,
  instanceLoading,
  telegramSetup,
  telegramPairing,
  setupComplete,
  dashboard,
}

/// 앱 초기화 완료 여부 (splash → 실제 화면 전환 제어)
final appInitializedProvider = StateProvider<bool>((ref) => false);

/// AI disclosure 동의 여부
final aiDisclosureAcceptedProvider = StateProvider<bool>((ref) => false);

/// 인스턴스 ready 이후 setup 진행 상태를 추적
final setupProgressProvider = StateProvider<OnboardingStep>((ref) {
  return OnboardingStep.telegramSetup;
});

final onboardingStepProvider = Provider<OnboardingStep>((ref) {
  final initialized = ref.watch(appInitializedProvider);
  if (!initialized) return OnboardingStep.initializing;

  final isPro = ref.watch(isProProvider);
  final authState = ref.watch(authProvider);
  final instanceState = ref.watch(instanceProvider);
  final setupProgress = ref.watch(setupProgressProvider);

  if (!isPro) return OnboardingStep.paywall;
  if (authState.status != AuthStatus.authenticated) return OnboardingStep.auth;

  final aiDisclosureAccepted = ref.watch(aiDisclosureAcceptedProvider);
  if (!aiDisclosureAccepted) return OnboardingStep.aiDisclosure;

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
