import 'dart:async';
import 'dart:math' as math;

import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/api_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/profile_provider.dart';

enum _StepStatus { pending, loading, done }

class FakeLoadingScreen extends ConsumerStatefulWidget {
  const FakeLoadingScreen({super.key});

  @override
  ConsumerState<FakeLoadingScreen> createState() => _FakeLoadingScreenState();
}

class _FakeLoadingScreenState extends ConsumerState<FakeLoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _rotateController;

  static const _stepTimings = [
    [0, 0],
    [0, 500],
    [500, 1500],
    [1500, 2500],
    [2500, 3500],
    [3500, 4000],
    [4000, 4500],
  ];

  late List<_StepStatus> _statuses;
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _statuses = List.filled(7, _StepStatus.pending);
    _statuses[0] = _StepStatus.done;

    _scheduleSteps();
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'fake_loading');
  }

  void _scheduleSteps() {
    for (int i = 1; i < _stepTimings.length; i++) {
      final showAt = _stepTimings[i][0];
      final completeAt = _stepTimings[i][1];

      _timers.add(
        Timer(Duration(milliseconds: showAt), () {
          if (!mounted) return;
          setState(() => _statuses[i] = _StepStatus.loading);
        }),
      );

      _timers.add(
        Timer(Duration(milliseconds: completeAt), () {
          if (!mounted) return;
          setState(() => _statuses[i] = _StepStatus.done);
        }),
      );
    }

    _timers.add(
      Timer(const Duration(milliseconds: 5000), () {
        if (!mounted) return;
        HapticFeedback.mediumImpact();
        ref.read(analyticsProvider).logOnboardingFakeLoadingCompleted();
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.agentComplete;
      }),
    );
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _rotateController.dispose();
    super.dispose();
  }

  String _getCreatureEmoji(String? creature) {
    const map = {
      'cat': '\u{1F431}',
      'dragon': '\u{1F432}',
      'fox': '\u{1F98A}',
      'owl': '\u{1F989}',
      'rabbit': '\u{1F430}',
      'bear': '\u{1F43B}',
      'dino': '\u{1F995}',
      'penguin': '\u{1F427}',
      'person': '\u{1F464}',
      'wolf': '\u{1F43A}',
      'panda': '\u{1F43C}',
      'unicorn': '\u{1F984}',
    };
    return map[creature] ?? '\u{1F916}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(profileProvider);
    final callName = profile.callName.isNotEmpty
        ? profile.callName
        : l10n.commonFallbackFriend;
    final agentName = profile.agentName.isNotEmpty
        ? profile.agentName
        : l10n.commonFallbackYourAgent;
    final creatureEmoji =
        profile.agentEmoji ?? _getCreatureEmoji(profile.creature);
    final vibe = profile.vibe ?? 'default';

    final steps = [
      '${l10n.fakeLoadingStep1} \u2014 $callName',
      '$agentName ${l10n.fakeLoadingStep2} \u2014 $vibe',
      l10n.fakeLoadingStep3,
      l10n.fakeLoadingStep4,
      l10n.fakeLoadingStep5,
      l10n.fakeLoadingStep6,
      l10n.fakeLoadingStep7,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      body: Stack(
        children: [
          // Hexgrid background
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding/hexgrid-v3.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Spinner with creature
                    _buildSpinner(creatureEmoji),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      l10n.fakeLoadingTitle(callName),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEAEAEB),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      l10n.fakeLoadingSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8A8B8D),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Progress steps
                    ...List.generate(steps.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildStep(steps[i], _statuses[i]),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpinner(String creatureEmoji) {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        final angle = _rotateController.value * 2 * math.pi;
        return SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            children: [
              // Background ring
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2E2E2E),
                      width: 3,
                    ),
                  ),
                ),
              ),
              // Gradient ring
              Positioned.fill(
                child: CustomPaint(painter: _GradientRingPainter(angle: angle)),
              ),
              // Creature emoji
              Center(
                child: Text(
                  creatureEmoji,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep(String text, _StepStatus status) {
    IconData icon;
    Color iconColor;
    Color textColor;

    switch (status) {
      case _StepStatus.done:
        icon = LucideIcons.checkCircle2;
        iconColor = const Color(0xFF3B82F6);
        textColor = const Color(0xFFEAEAEB);
      case _StepStatus.loading:
        icon = LucideIcons.loader;
        iconColor = const Color(0xFF3B82F6);
        textColor = const Color(0xFF3B82F6);
      case _StepStatus.pending:
        icon = LucideIcons.circle;
        iconColor = const Color(0xFF444444);
        textColor = const Color(0xFF555555);
    }

    final iconWidget = Icon(icon, size: 18, color: iconColor);

    return Row(
      children: [
        if (status == _StepStatus.loading)
          AnimatedBuilder(
            animation: _rotateController,
            builder: (context, child) => Transform.rotate(
              angle: _rotateController.value * 2 * math.pi,
              child: child,
            ),
            child: iconWidget,
          )
        else
          iconWidget,
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  final double angle;

  _GradientRingPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = SweepGradient(
        startAngle: angle,
        endAngle: angle + math.pi * 2,
        colors: const [Color(0xFF3B82F6), Colors.transparent],
        stops: const [0.0, 0.7],
      ).createShader(rect);

    canvas.drawOval(rect.deflate(1.5), paint);
  }

  @override
  bool shouldRepaint(_GradientRingPainter oldDelegate) =>
      angle != oldDelegate.angle;
}
