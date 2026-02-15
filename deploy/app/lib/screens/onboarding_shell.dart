import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/onboarding_provider.dart';
import '../theme/app_theme.dart';

class OnboardingShell extends ConsumerWidget {
  final Widget child;

  const OnboardingShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(onboardingStepProvider);
    final currentIndex = _stepIndex(step);
    final totalSteps = 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (currentIndex + 1) / totalSteps,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            minHeight: 3,
          ),
        ),
      ),
      body: child,
    );
  }

  int _stepIndex(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.instanceLoading:
        return 0;
      case OnboardingStep.telegramSetup:
        return 1;
      case OnboardingStep.telegramPairing:
        return 2;
      default:
        return 0;
    }
  }
}
