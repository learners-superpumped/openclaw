import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/api_provider.dart';
import '../../providers/onboarding_provider.dart';
import 'widgets/onboarding_scaffold.dart';

class _PressHeadline {
  final String logoAsset;
  final String quote;

  const _PressHeadline({required this.logoAsset, required this.quote});
}

const _headlines = [
  _PressHeadline(
    logoAsset: 'assets/images/onboarding/cnbc-w.png',
    quote:
        '\u201CFrom Clawdbot to ClawBox: Meet the AI agent generating buzz globally\u201D',
  ),
  _PressHeadline(
    logoAsset: 'assets/images/onboarding/bloomberg-w.png',
    quote:
        '\u201CClawBox\u2019s an AI Sensation, But Its Security a Work in Progress\u201D',
  ),
  _PressHeadline(
    logoAsset: 'assets/images/onboarding/fortune-w.png',
    quote: '\u201CWho is ClawBox creator Peter Steinberger?\u201D',
  ),
  _PressHeadline(
    logoAsset: 'assets/images/onboarding/techcrunch-w.png',
    quote: '\u201CClawBox creator Peter Steinberger joins OpenAI\u201D',
  ),
  _PressHeadline(
    logoAsset: 'assets/images/onboarding/cnn-w.png',
    quote: '\u201COpenAI hires \u2018genius\u2019 ClawBox creator\u201D',
  ),
];

class GithubPressScreen extends ConsumerWidget {
  const GithubPressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'github_press');
    return OnboardingScaffold(
      showBackButton: true,
      onBackPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(analyticsProvider)
            .logOnboardingBackTapped(fromStep: 'github_press');
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.taskSelection;
      },
      showLogo: false,
      buttonText: l10n.commonContinue,
      onButtonPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(analyticsProvider)
            .logOnboardingStepCompleted(step: 'github_press');
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.tweets;
      },
      body: Column(
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  l10n.onboardingBadgeTopApp,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
          ),

          // Star section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Text(
                  l10n.onboardingGithubStarCount,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFEAEAEB),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.star,
                      color: const Color(0xFF8A8B8D),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.onboardingGithubStarsLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8A8B8D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.onboardingGithubFastestGrowing,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A8B8D),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.onboardingGithubStarsSingleDay,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8A8B8D),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // Headlines
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  for (int i = 0; i < _headlines.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    Expanded(child: _buildHeadlineCard(_headlines[i])),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadlineCard(_PressHeadline headline) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF141415),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1F2023)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 20,
            child: Image.asset(headline.logoAsset, fit: BoxFit.contain),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              headline.quote,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEAEAEB),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
