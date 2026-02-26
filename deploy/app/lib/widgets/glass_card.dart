import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blurSigma;
  final Color? glowColor;
  final double glowIntensity;
  final VoidCallback? onTap;
  final bool solid;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 24,
    this.blurSigma = 12,
    this.glowColor,
    this.glowIntensity = 0.0,
    this.onTap,
  }) : solid = false;

  const GlassCard.solid({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 24,
    this.glowColor,
    this.glowIntensity = 0.0,
    this.onTap,
  }) : blurSigma = 0,
       solid = true;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final hasGlow = widget.glowColor != null && widget.glowIntensity > 0;
    final radius = BorderRadius.circular(widget.borderRadius);

    final container = Container(
      decoration: BoxDecoration(
        color: GlassColors.glassSurface,
        borderRadius: radius,
        border: Border.all(
          color: hasGlow
              ? GlassColors.glassBorderAccent
              : GlassColors.glassBorder,
          width: 0.5,
        ),
        boxShadow: [
          const BoxShadow(
            color: Color(0x40000000),
            blurRadius: 24,
            offset: Offset(0, 8),
            spreadRadius: -4,
          ),
          if (hasGlow)
            BoxShadow(
              color: widget.glowColor!.withValues(
                alpha: widget.glowIntensity * 0.3,
              ),
              blurRadius: 32,
              spreadRadius: -4,
            ),
        ],
      ),
      child: Stack(
        children: [
          // Inner shine — top highlight line
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.borderRadius),
                  topRight: Radius.circular(widget.borderRadius),
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0x00FFFFFF),
                    GlassColors.innerShine,
                    Color(0x00FFFFFF),
                  ],
                ),
              ),
            ),
          ),
          Padding(padding: widget.padding, child: widget.child),
        ],
      ),
    );

    Widget content;
    if (widget.solid) {
      content = ClipRRect(borderRadius: radius, child: container);
    } else {
      content = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blurSigma,
            sigmaY: widget.blurSigma,
          ),
          child: container,
        ),
      );
    }

    final scaled = AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      child: content,
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          HapticFeedback.lightImpact();
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: scaled,
      );
    }

    return scaled;
  }
}
