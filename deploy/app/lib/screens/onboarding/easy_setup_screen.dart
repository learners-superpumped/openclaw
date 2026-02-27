import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/api_provider.dart';
import '../../providers/onboarding_provider.dart';
import 'widgets/onboarding_scaffold.dart';

class EasySetupScreen extends ConsumerWidget {
  const EasySetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'easy_setup');
    return OnboardingScaffold(
      showBackButton: true,
      showLogo: false,
      onBackPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(analyticsProvider)
            .logOnboardingBackTapped(fromStep: 'easy_setup');
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.tweets;
      },
      buttonText: l10n.getStarted,
      onButtonPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(analyticsProvider)
            .logOnboardingStepCompleted(step: 'easy_setup');
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.safeByDesign;
      },
      body: Column(
        children: [
          // Page indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _PageIndicator(activeIndex: 0),
          ),

          // Content — vertically centered
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon in rounded square
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1B1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.mousePointerClick,
                        size: 28,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    l10n.onboardingEasySetupTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEAEAEB),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Subtitle
                  Text(
                    l10n.onboardingEasySetupSubtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF8A8B8D),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // No-list items
                  _NoItem(text: l10n.onboardingEasySetupNoApiKeys),
                  const SizedBox(height: 12),
                  _NoItem(text: l10n.onboardingEasySetupNoTerminal),
                  const SizedBox(height: 12),
                  _NoItem(text: l10n.onboardingEasySetupNoServer),
                  const SizedBox(height: 12),
                  _NoItem(text: l10n.onboardingEasySetupNoTechKnowledge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoItem extends StatelessWidget {
  final String text;

  const _NoItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(LucideIcons.x, size: 16, color: Color(0xFF8A8B8D)),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFEAEAEB),
          ),
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int activeIndex;

  const _PageIndicator({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == activeIndex;
        return Container(
          width: isActive ? 8 : 6,
          height: isActive ? 8 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF444444),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
