import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../../models/usage.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class UsageTile extends StatelessWidget {
  final Usage? usage;
  final bool isLoading;
  const UsageTile({super.key, this.usage, this.isLoading = false});

  String _resetLabel(AppLocalizations l10n) {
    switch (usage?.limitReset) {
      case 'monthly':
        return l10n.resetsMonthly;
      case 'daily':
        return l10n.resetsDaily;
      default:
        return l10n.resetsWeekly;
    }
  }

  Color _barColor(double fraction) {
    if (fraction >= 0.9) return AppColors.error;
    if (fraction >= 0.7) return AppColors.warning;
    return AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final loading = isLoading || usage == null;
    final fraction = usage?.fraction ?? 0.0;
    final color = _barColor(fraction);

    return GlassCard.solid(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.aiUsage.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              Skeletonizer(
                enabled: loading,
                child: Text(
                  loading ? l10n.resetsWeekly : _resetLabel(l10n),
                  style: TextStyle(color: AppColors.textTertiary, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Skeletonizer(
            enabled: loading,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${usage?.usage ?? 0}',
                  style: TextStyle(
                    color: loading ? AppColors.textTertiary : color,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 2),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    ' / 100',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (loading)
            Skeletonizer(
              enabled: true,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            )
          else
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: fraction),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 8),
                  painter: _GlassProgressPainter(fraction: value, color: color),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ─── Glass Progress Bar Painter ────────────────────────────────────────────

class _GlassProgressPainter extends CustomPainter {
  final double fraction;
  final Color color;

  _GlassProgressPainter({required this.fraction, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = GlassColors.glassSurface
      ..style = PaintingStyle.fill;

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(4),
    );
    canvas.drawRRect(bgRect, bgPaint);

    if (fraction > 0) {
      final fillWidth = size.width * fraction;
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, fillWidth, size.height),
        const Radius.circular(4),
      );

      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
        ).createShader(Rect.fromLTWH(0, 0, fillWidth, size.height))
        ..style = PaintingStyle.fill;

      canvas.drawRRect(fillRect, fillPaint);

      // Glow effect
      final glowPaint = Paint()
        ..shader = LinearGradient(
          colors: [color.withValues(alpha: 0.4), color.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, fillWidth, size.height))
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawRRect(fillRect, glowPaint);
    }
  }

  @override
  bool shouldRepaint(_GlassProgressPainter oldDelegate) {
    return oldDelegate.fraction != fraction || oldDelegate.color != color;
  }
}
