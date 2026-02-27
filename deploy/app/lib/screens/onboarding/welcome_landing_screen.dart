import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/api_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/subscription_provider.dart'; // for offeringsProvider prefetch

// --- Tweet data model ---

class _TweetData {
  final String name;
  final String quote;
  final String profileImage;

  const _TweetData({
    required this.name,
    required this.quote,
    required this.profileImage,
  });
}

// --- Tweet rows matching pencil.dev design exactly ---

const _row1 = [
  _TweetData(
    name: 'Sam Altman',
    quote: 'A genius with amazing ideas about the future of smart agents',
    profileImage: 'assets/images/onboarding/pfp-sama.jpg',
  ),
  _TweetData(
    name: 'Lex Fridman',
    quote: 'An open-source AI agent taken the Internet by storm',
    profileImage: 'assets/images/onboarding/pfp-lexfridman.jpg',
  ),
  _TweetData(
    name: 'Romain Huet',
    quote: 'Proud to support @steipete and @openclaw in this chapter',
    profileImage: 'assets/images/onboarding/pfp-romainhuet.jpg',
  ),
  _TweetData(
    name: 'Peter Steinberger',
    quote: 'Joining @OpenAI to bring agents to everyone',
    profileImage: 'assets/images/onboarding/pfp-steipete.jpg',
  ),
  _TweetData(
    name: 'Andrej Karpathy',
    quote: 'Running each agent in its own isolated cloud',
    profileImage: 'assets/images/onboarding/pfp-karpathy.jpg',
  ),
  _TweetData(
    name: 'Pieter Levels',
    quote: 'Built my entire business workflow on ClawBox. 10x productive',
    profileImage: 'assets/images/onboarding/pfp-levelsio.jpg',
  ),
  _TweetData(
    name: 'Simon Willison',
    quote: 'Architecture is genuinely impressive. Proper isolation',
    profileImage: 'assets/images/onboarding/pfp-simonw.jpg',
  ),
];

const _row2 = [
  _TweetData(
    name: 'Guillermo Rauch',
    quote: 'AI agents that actually ship. ClawBox gets this right',
    profileImage: 'assets/images/onboarding/pfp-rauchg.jpg',
  ),
  _TweetData(
    name: 'Theo Browne',
    quote: 'Was skeptical about AI agents until I tried ClawBox',
    profileImage: 'assets/images/onboarding/pfp-t3dotgg.jpg',
  ),
  _TweetData(
    name: 'Sarah Guo',
    quote: 'Every founder I talk to is watching ClawBox',
    profileImage: 'assets/images/onboarding/pfp-saranormous.jpg',
  ),
  _TweetData(
    name: 'Elad Gil',
    quote: 'Most interesting AI product since ChatGPT',
    profileImage: 'assets/images/onboarding/pfp-eladgil.jpg',
  ),
  _TweetData(
    name: 'Amjad Masad',
    quote: 'Personal AI agents are the future of computing',
    profileImage: 'assets/images/onboarding/pfp-amasad.jpg',
  ),
  _TweetData(
    name: 'Nat Friedman',
    quote: 'Finally someone built AI agents the right way',
    profileImage: 'assets/images/onboarding/pfp-natfriedman.jpg',
  ),
  _TweetData(
    name: 'Shreyas Doshi',
    quote: 'Solves the last-mile problem of AI',
    profileImage: 'assets/images/onboarding/pfp-shreyas.jpg',
  ),
];

const _row3 = [
  _TweetData(
    name: 'Andrej Karpathy',
    quote: 'Security-first. Isolated cloud is how agents should work',
    profileImage: 'assets/images/onboarding/pfp-karpathy.jpg',
  ),
  _TweetData(
    name: 'Sarah Guo',
    quote: 'This is the inflection point for AI agents',
    profileImage: 'assets/images/onboarding/pfp-saranormous.jpg',
  ),
  _TweetData(
    name: 'Pieter Levels',
    quote: '10x more productive. Not going back',
    profileImage: 'assets/images/onboarding/pfp-levelsio.jpg',
  ),
  _TweetData(
    name: 'Nat Friedman',
    quote: 'Dedicated compute, real isolation, real results',
    profileImage: 'assets/images/onboarding/pfp-natfriedman.jpg',
  ),
  _TweetData(
    name: 'Elad Gil',
    quote: 'The agent paradigm is real',
    profileImage: 'assets/images/onboarding/pfp-eladgil.jpg',
  ),
  _TweetData(
    name: 'Guillermo Rauch',
    quote: 'AI agents that actually ship',
    profileImage: 'assets/images/onboarding/pfp-rauchg.jpg',
  ),
  _TweetData(
    name: 'Sam Altman',
    quote: 'A genius with amazing ideas about smart agents',
    profileImage: 'assets/images/onboarding/pfp-sama.jpg',
  ),
];

// --- Card dimensions matching design: 200x42, gap 8 ---
const double _cardWidth = 200;
const double _cardGap = 8;
const double _cardHeight = 42;

class WelcomeLandingScreen extends ConsumerStatefulWidget {
  const WelcomeLandingScreen({super.key});

  @override
  ConsumerState<WelcomeLandingScreen> createState() =>
      _WelcomeLandingScreenState();
}

class _WelcomeLandingScreenState extends ConsumerState<WelcomeLandingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller1;
  late final AnimationController _controller2;
  late final AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    // Prefetch RevenueCat offerings so paywall loads instantly
    ref.read(offeringsProvider);
    ref
        .read(analyticsProvider)
        .logOnboardingStepViewed(step: 'welcome_landing');
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 35),
    )..repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      body: Stack(
        children: [
          // Background hexgrid pattern
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding/hexgrid-v3.png',
              fit: BoxFit.cover,
            ),
          ),

          // Tweet Row 1 — top area, opacity 0.8
          Positioned(
            left: 0,
            right: 0,
            top: 55,
            child: Opacity(
              opacity: 0.8,
              child: _ScrollingTweetRow(
                tweets: _row1,
                controller: _controller1,
                reverse: false,
                initialOffset: -200,
              ),
            ),
          ),

          // Tweet Row 2 — below row 1, opacity 0.7
          Positioned(
            left: 0,
            right: 0,
            top: 105,
            child: Opacity(
              opacity: 0.7,
              child: _ScrollingTweetRow(
                tweets: _row2,
                controller: _controller2,
                reverse: true,
                initialOffset: -380,
              ),
            ),
          ),

          // Tweet Row 3 — bottom area, opacity 0.75
          Positioned(
            left: 0,
            right: 0,
            bottom: 166,
            child: Opacity(
              opacity: 0.75,
              child: _ScrollingTweetRow(
                tweets: _row3,
                controller: _controller3,
                reverse: false,
                initialOffset: -120,
              ),
            ),
          ),

          // Gradient overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0A0A0B).withValues(alpha: 0.3),
                    const Color(0xFF0A0A0B).withValues(alpha: 0.7),
                    const Color(0xFF0A0A0B).withValues(alpha: 0.95),
                    const Color(0xFF0A0A0B),
                  ],
                  stops: const [0.0, 0.35, 0.55, 0.7],
                ),
              ),
            ),
          ),

          // Center content
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Spacer(flex: 2),

                  // Hero section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        // Badge: #1 OpenClaw App
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.onboardingBadgeTopApp,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Hero title
                        Text(
                          l10n.onboardingWelcomeTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEAEAEB),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Subtitle
                        Text(
                          l10n.onboardingWelcomeSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8A8B8D),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Proof area
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        // GitHub Stars badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF141415),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0xFF1F2023)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.star,
                                color: const Color(0xFF8A8B8D),
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.onboardingGithubStarsBadge,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFEAEAEB),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Press logos row
                        Opacity(
                          opacity: 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _pressLogo('bloomberg-w.png'),
                              const SizedBox(width: 12),
                              _pressLogo('fortune-w.png'),
                              const SizedBox(width: 12),
                              _pressLogo('cnn-w.png'),
                              const SizedBox(width: 12),
                              _pressLogo('techcrunch-w.png'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // LLM models row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _llmIcon('openai-icon.png'),
                            const SizedBox(width: 6),
                            _llmIcon('anthropic-icon.png'),
                            const SizedBox(width: 6),
                            _llmIcon('gemini-icon.png'),
                            const SizedBox(width: 6),
                            _llmIcon('mistral-icon.png'),
                            const SizedBox(width: 6),
                            _llmIcon('deepseek-icon.png'),
                            const SizedBox(width: 6),
                            Text(
                              l10n.onboardingPoweredByModels,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Quote strip
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          l10n.onboardingQuoteSamAltman,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.onboardingQuoteSamAltmanAttribution,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Get Started button area
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          ref
                              .read(analyticsProvider)
                              .logOnboardingGetStartedTapped();
                          ref.read(onboardingScreenProvider.notifier).state =
                              OnboardingStep.userProfile;
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: Text(l10n.getStarted),
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

  Widget _pressLogo(String filename) {
    return Image.asset(
      'assets/images/onboarding/$filename',
      height: 18,
      width: 50,
      fit: BoxFit.contain,
    );
  }

  Widget _llmIcon(String filename) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(
        'assets/images/onboarding/$filename',
        width: 20,
        height: 20,
        fit: BoxFit.cover,
      ),
    );
  }
}

// --- Scrolling tweet row ---

class _ScrollingTweetRow extends StatelessWidget {
  final List<_TweetData> tweets;
  final AnimationController controller;
  final bool reverse;
  final double initialOffset;

  const _ScrollingTweetRow({
    required this.tweets,
    required this.controller,
    required this.reverse,
    this.initialOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Triple the tweets so there's always enough content visible
    final tripled = [...tweets, ...tweets, ...tweets];
    final oneSetWidth = tweets.length * (_cardWidth + _cardGap);

    return ClipRect(
      child: SizedBox(
        height: _cardHeight,
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.centerLeft,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              // Modulo ensures seamless infinite loop — resets after one set
              final rawOffset = controller.value * oneSetWidth;
              final animOffset = reverse ? rawOffset : -rawOffset;
              return Transform.translate(
                offset: Offset(initialOffset + animOffset, 0),
                child: child,
              );
            },
            child: Row(
              children: tripled.map((tweet) {
                return Padding(
                  padding: const EdgeInsets.only(right: _cardGap),
                  child: _TweetCard(tweet: tweet),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Tweet card: 200x42, matching pencil design ---

class _TweetCard extends StatelessWidget {
  final _TweetData tweet;

  const _TweetCard({required this.tweet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _cardWidth,
      height: _cardHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF141415),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1F2023)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile image (20x20 circle)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              tweet.profileImage,
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 6),
          // "Name  Quote" single text block
          Expanded(
            child: Text(
              '${tweet.name}  ${tweet.quote}',
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.normal,
                color: Color(0xFF999999),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
