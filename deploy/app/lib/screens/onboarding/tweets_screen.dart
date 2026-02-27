import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/onboarding_provider.dart';
import 'widgets/onboarding_scaffold.dart';

class _Tweet {
  final String name;
  final String handle;
  final String text;
  final String pfpAsset;

  const _Tweet({
    required this.name,
    required this.handle,
    required this.text,
    required this.pfpAsset,
  });
}

const _tweets = [
  _Tweet(
    name: 'Sam Altman',
    handle: '@sama',
    text:
        'A genius with a lot of amazing ideas about the future of very smart agents interacting with each other to do very useful things for people.',
    pfpAsset: 'assets/images/onboarding/pfp-sama.jpg',
  ),
  _Tweet(
    name: 'Lex Fridman',
    handle: '@lexfridman',
    text:
        'An open-source AI agent that has taken the Internet by storm, with now over 180,000 stars on GitHub.',
    pfpAsset: 'assets/images/onboarding/pfp-lexfridman.jpg',
  ),
  _Tweet(
    name: 'Romain Huet',
    handle: '@romainhuet',
    text:
        'Proud to continue supporting @steipete and @openclaw in this new chapter... The claw is the law',
    pfpAsset: 'assets/images/onboarding/pfp-romainhuet.jpg',
  ),
  _Tweet(
    name: 'Peter Steinberger',
    handle: '@steipete',
    text:
        "I'm joining @OpenAI to bring agents to everyone. @ClawBox is becoming a foundation: open, independent, and just getting started.",
    pfpAsset: 'assets/images/onboarding/pfp-steipete.jpg',
  ),
  _Tweet(
    name: 'Andrej Karpathy',
    handle: '@karpathy',
    text:
        'ClawBox running each agent in its own isolated cloud is exactly how AI agents should work. Security-first.',
    pfpAsset: 'assets/images/onboarding/pfp-karpathy.jpg',
  ),
  _Tweet(
    name: 'Pieter Levels',
    handle: '@levelsio',
    text:
        'Built my entire business workflow on ClawBox. 10x more productive. Not going back.',
    pfpAsset: 'assets/images/onboarding/pfp-levelsio.jpg',
  ),
  _Tweet(
    name: 'Simon Willison',
    handle: '@simonw',
    text:
        "ClawBox's architecture is genuinely impressive. Proper isolation, proper security, proper AI.",
    pfpAsset: 'assets/images/onboarding/pfp-simonw.jpg',
  ),
  _Tweet(
    name: 'Guillermo Rauch',
    handle: '@rauchg',
    text: 'AI agents that actually ship. ClawBox gets this right.',
    pfpAsset: 'assets/images/onboarding/pfp-rauchg.jpg',
  ),
  _Tweet(
    name: 'Theo Browne',
    handle: '@t3dotgg',
    text:
        'Was skeptical about AI agents until I tried ClawBox. Completely changed my mind.',
    pfpAsset: 'assets/images/onboarding/pfp-t3dotgg.jpg',
  ),
  _Tweet(
    name: 'Sarah Guo',
    handle: '@saranormous',
    text:
        'Every founder I talk to is watching ClawBox. This is the inflection point for AI agents.',
    pfpAsset: 'assets/images/onboarding/pfp-saranormous.jpg',
  ),
  _Tweet(
    name: 'Elad Gil',
    handle: '@eladgil',
    text:
        'Most interesting AI product since ChatGPT. The agent paradigm is real.',
    pfpAsset: 'assets/images/onboarding/pfp-eladgil.jpg',
  ),
  _Tweet(
    name: 'Amjad Masad',
    handle: '@amasad',
    text:
        'Personal AI agents are the future of computing. ClawBox is leading the way.',
    pfpAsset: 'assets/images/onboarding/pfp-amasad.jpg',
  ),
  _Tweet(
    name: 'Nat Friedman',
    handle: '@natfriedman',
    text:
        'Finally someone built AI agents the right way. Dedicated compute, real isolation, real results.',
    pfpAsset: 'assets/images/onboarding/pfp-natfriedman.jpg',
  ),
  _Tweet(
    name: 'Shreyas Doshi',
    handle: '@shreyas',
    text:
        "ClawBox solves the last-mile problem of AI. It doesn't just think \u2014 it acts.",
    pfpAsset: 'assets/images/onboarding/pfp-shreyas.jpg',
  ),
];

class TweetsScreen extends ConsumerWidget {
  const TweetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return OnboardingScaffold(
      showBackButton: true,
      onBackPressed: () {
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.githubPress;
      },
      showLogo: false,
      buttonText: l10n.commonContinue,
      onButtonPressed: () {
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.easySetup;
      },
      body: Column(
        children: [
          // Header
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
                const SizedBox(height: 6),
                Text(
                  l10n.onboardingTweetsSectionTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEAEAEB),
                  ),
                ),
              ],
            ),
          ),

          // Tweet cards — scrollable
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: _tweets.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _buildTweetCard(_tweets[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTweetCard(_Tweet tweet) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141415),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1F2023)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              tweet.pfpAsset,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${tweet.name}  ${tweet.handle}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEAEAEB),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tweet.text,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFFABABAC),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
