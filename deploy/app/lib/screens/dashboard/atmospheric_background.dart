import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class AtmosphericBackground extends StatelessWidget {
  final AnimationController animation;

  const AtmosphericBackground({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final v = animation.value;
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0D0D0F), AppColors.background],
              ),
            ),
            child: Stack(
              children: [
                // Orb 1: Cyan, top-right
                Positioned(
                  right: -60 + (v * 20),
                  top: 40 + (v * 15),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          GlassColors.orbCyan.withValues(alpha: 0.08),
                          GlassColors.orbCyan.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                // Orb 2: Purple, bottom-left
                Positioned(
                  left: -50 + (v * 10),
                  bottom: 200 - (v * 20),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          GlassColors.orbPurple.withValues(alpha: 0.06),
                          GlassColors.orbPurple.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                // Orb 3: Teal, center-right
                Positioned(
                  right: 20 - (v * 15),
                  top: 350 + (v * 10),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          GlassColors.orbTeal.withValues(alpha: 0.05),
                          GlassColors.orbTeal.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
