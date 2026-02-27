import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/api_provider.dart';
import '../../providers/onboarding_provider.dart';
import 'widgets/onboarding_scaffold.dart';

const _complianceTags = ['SOC 2', 'ISO 27001', 'FedRAMP', 'PCI DSS', 'HIPAA'];

class SafeByDesignScreen extends ConsumerWidget {
  const SafeByDesignScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final checkItems = [
      l10n.onboardingSafeByDesignCheck1,
      l10n.onboardingSafeByDesignCheck2,
      l10n.onboardingSafeByDesignCheck3,
    ];
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'safe_by_design');
    return OnboardingScaffold(
      showBackButton: true,
      showLogo: false,
      onBackPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(analyticsProvider)
            .logOnboardingBackTapped(fromStep: 'safe_by_design');
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.easySetup;
      },
      buttonText: l10n.commonContinue,
      onButtonPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(analyticsProvider)
            .logOnboardingStepCompleted(step: 'safe_by_design');
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.fullFeatures;
      },
      body: Column(
        children: [
          // Page indicator (2nd active)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _PageIndicator(activeIndex: 1),
          ),

          // Content — vertically centered
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shield icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1B1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.shieldCheck,
                        size: 28,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    l10n.onboardingSafeByDesignTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEAEAEB),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bloomberg news card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141415),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF1F2023)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.onboardingSafeByDesignPressQuote,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFEAEAEB),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 80,
                          height: 16,
                          child: Image.asset(
                            'assets/images/onboarding/bloomberg-w.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    l10n.onboardingSafeByDesignSubtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A8B8D),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Check items
                  ...checkItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.check,
                            size: 16,
                            color: Color(0xFF3B82F6),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            item,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFEAEAEB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // AWS badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141415),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF1F2023)),
                    ),
                    child: SizedBox(
                      width: 80,
                      height: 28,
                      child: Image.asset(
                        'assets/images/onboarding/aws-logo-white-v2.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Compliance tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _complianceTags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141415),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF1F2023)),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8A8B8D),
                          ),
                        ),
                      );
                    }).toList(),
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
