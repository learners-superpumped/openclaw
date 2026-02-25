import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class ChatHeroTile extends StatefulWidget {
  final bool isReady;
  final VoidCallback? onTap;

  const ChatHeroTile({super.key, required this.isReady, this.onTap});

  @override
  State<ChatHeroTile> createState() => _ChatHeroTileState();
}

class _ChatHeroTileState extends State<ChatHeroTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard(
      glowColor: AppColors.accent,
      glowIntensity: 0.5,
      padding: EdgeInsets.zero,
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Animated glow orbs
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (context, _) {
                  final t = _glowController.value;
                  // Orb 1: cyan, moves clockwise
                  final x1 = 0.3 + 0.4 * math.cos(t * 2 * math.pi);
                  final y1 = 0.3 + 0.4 * math.sin(t * 2 * math.pi);
                  // Orb 2: purple, moves counter-clockwise, offset phase
                  final x2 = 0.6 - 0.3 * math.cos(t * 2 * math.pi + 2.0);
                  final y2 = 0.7 + 0.3 * math.sin(t * 2 * math.pi + 2.0);
                  // Orb 3: teal, slower drift
                  final x3 = 0.8 + 0.2 * math.sin(t * 2 * math.pi * 0.7);
                  final y3 = 0.2 + 0.3 * math.cos(t * 2 * math.pi * 0.7);

                  return CustomPaint(
                    painter: _GlowOrbsPainter(
                      orbs: [
                        _GlowOrb(x1, y1, 120, GlassColors.orbCyan, 0.12),
                        _GlowOrb(x2, y2, 100, GlassColors.orbPurple, 0.10),
                        _GlowOrb(x3, y3, 80, GlassColors.orbTeal, 0.08),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _PulsingGlowIcon(
                        icon: Icons.auto_awesome,
                        color: AppColors.accent,
                        size: 48,
                      ),
                      const Spacer(),
                      _StatusPill(isReady: widget.isReady),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.chatWithAI,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.isReady ? l10n.agentReady : l10n.agentStarting,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.accent.withValues(alpha: 0.7),
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Glow Orbs Painter ─────────────────────────────────────────────────────

class _GlowOrb {
  final double x, y, radius;
  final Color color;
  final double opacity;
  const _GlowOrb(this.x, this.y, this.radius, this.color, this.opacity);
}

class _GlowOrbsPainter extends CustomPainter {
  final List<_GlowOrb> orbs;
  _GlowOrbsPainter({required this.orbs});

  @override
  void paint(Canvas canvas, Size size) {
    for (final orb in orbs) {
      final center = Offset(orb.x * size.width, orb.y * size.height);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            orb.color.withValues(alpha: orb.opacity),
            orb.color.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: orb.radius))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_GlowOrbsPainter oldDelegate) => true;
}

// ─── Pulsing Glow Icon ─────────────────────────────────────────────────────

class _PulsingGlowIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _PulsingGlowIcon({
    required this.icon,
    required this.color,
    this.size = 48,
  });

  @override
  State<_PulsingGlowIcon> createState() => _PulsingGlowIconState();
}

class _PulsingGlowIconState extends State<_PulsingGlowIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glowOpacity = 0.1 + (_controller.value * 0.15);
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(alpha: glowOpacity),
          ),
          child: child,
        );
      },
      child: Icon(widget.icon, color: widget.color, size: widget.size * 0.5),
    );
  }
}

// ─── Status Pill ───────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  final bool isReady;

  const _StatusPill({required this.isReady});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = isReady ? AppColors.accent : AppColors.textTertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            isReady ? l10n.agentReady : l10n.agentStarting,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
