import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'instance_provider.dart';
import 'subscription_provider.dart';

enum OnboardingStep {
  initializing,
  auth,
  welcomeLanding,
  userProfile,
  agentCreation,
  vibeSelection,
  taskSelection,
  githubPress,
  tweets,
  easySetup,
  safeByDesign,
  fullFeatures,
  fakeLoading,
  agentComplete,
  newPaywall,
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

/// 온보딩 프로필 완료 여부 (새 온보딩 플로우를 이미 마친 사용자는 skip)
final profileCompletedProvider = StateProvider<bool>((ref) => false);

/// 온보딩 서브 화면 추적 (welcomeLanding ~ agentComplete)
final onboardingScreenProvider = StateProvider<OnboardingStep>((ref) {
  return OnboardingStep.welcomeLanding;
});

/// 인스턴스 ready 이후 setup 진행 상태를 추적
final setupProgressProvider = StateProvider<OnboardingStep>((ref) {
  return OnboardingStep.telegramSetup;
});

final onboardingStepProvider = Provider<OnboardingStep>((ref) {
  final initialized = ref.watch(appInitializedProvider);
  if (!initialized) return OnboardingStep.initializing;

  final authState = ref.watch(authProvider);
  if (authState.status != AuthStatus.authenticated) return OnboardingStep.auth;

  final profileCompleted = ref.watch(profileCompletedProvider);
  if (!profileCompleted) return ref.watch(onboardingScreenProvider);

  final isPro = ref.watch(isProProvider);
  if (!isPro) return OnboardingStep.newPaywall;

  final aiDisclosureAccepted = ref.watch(aiDisclosureAcceptedProvider);
  if (!aiDisclosureAccepted) return OnboardingStep.aiDisclosure;

  final instanceState = ref.watch(instanceProvider);
  final setupProgress = ref.watch(setupProgressProvider);

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
