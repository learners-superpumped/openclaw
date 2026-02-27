import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/api_provider.dart';
import '../../providers/onboarding_provider.dart';
import 'widgets/onboarding_scaffold.dart';

class _ExampleCard {
  final IconData icon;
  final String text;

  const _ExampleCard({required this.icon, required this.text});
}

class FullFeaturesScreen extends ConsumerWidget {
  const FullFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final examples = [
      _ExampleCard(
        icon: LucideIcons.mail,
        text: l10n.onboardingFullFeaturesExample1,
      ),
      _ExampleCard(
        icon: LucideIcons.shoppingCart,
        text: l10n.onboardingFullFeaturesExample2,
      ),
      _ExampleCard(
        icon: LucideIcons.plane,
        text: l10n.onboardingFullFeaturesExample3,
      ),
    ];

    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'full_features');

    return OnboardingScaffold(
      showBackButton: true,
      showLogo: false,
      onBackPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(analyticsProvider)
            .logOnboardingBackTapped(fromStep: 'full_features');
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.safeByDesign;
      },
      buttonText: l10n.commonContinue,
      onButtonPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(analyticsProvider)
            .logOnboardingStepCompleted(step: 'full_features');
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.fakeLoading;
      },
      body: Column(
        children: [
          // Page indicator (3rd active)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _PageIndicator(activeIndex: 2),
          ),

          // Content — vertically centered
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Layers icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1B1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.layers,
                        size: 28,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Title
                  Text(
                    l10n.onboardingFullFeaturesTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEAEAEB),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Subtitle
                  Text(
                    l10n.onboardingFullFeaturesSubtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A8B8D),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Example cards
                  ...List.generate(examples.length, (index) {
                    final example = examples[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < examples.length - 1 ? 10 : 0,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141415),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF1F2023)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              example.icon,
                              size: 18,
                              color: const Color(0xFF3B82F6),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                example.text,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFEAEAEB),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 18),

                  // Tagline
                  Center(
                    child: Text(
                      l10n.onboardingFullFeaturesTagline,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
