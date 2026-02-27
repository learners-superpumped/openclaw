import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GlassColors.glassSurface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: GlassColors.glassBorder),
      ),
      child: child,
    );
  }
}
