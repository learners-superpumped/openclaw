import 'package:flutter/material.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../../models/instance.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class InstanceTile extends StatelessWidget {
  final Instance instance;

  const InstanceTile({super.key, required this.instance});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard.solid(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.instance.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.dns_outlined,
                color: AppColors.textSecondary,
                size: 28,
              ),
              const SizedBox(width: 8),
              _PulsingDot(
                color: instance.isReady
                    ? AppColors.accent
                    : AppColors.textTertiary,
                isActive: instance.isReady,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            instance.isReady
                ? l10n.statusRunning
                : (instance.manager?.phase ?? l10n.statusWaiting),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: instance.isReady
                  ? AppColors.accent
                  : AppColors.textTertiary,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (instance.displayName != null) ...[
            const SizedBox(height: 2),
            Text(
              instance.displayName!,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Pulsing Dot ───────────────────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  final Color color;
  final bool isActive;

  const _PulsingDot({required this.color, required this.isActive});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    if (widget.isActive) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_PulsingDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
    }
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
      builder: (context, _) {
        final scale = widget.isActive ? 1.0 + (_controller.value * 0.3) : 1.0;
        return Container(
          width: 10 * scale,
          height: 10 * scale,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: widget.color.withValues(
                        alpha: 0.4 * _controller.value,
                      ),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}
