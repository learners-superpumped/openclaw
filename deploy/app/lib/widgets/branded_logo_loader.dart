import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BrandedLogoLoader extends StatefulWidget {
  final bool animate;
  final bool showProgressBar;
  final double logoSize;

  const BrandedLogoLoader({
    super.key,
    this.animate = false,
    this.showProgressBar = false,
    this.logoSize = 120,
  });

  @override
  State<BrandedLogoLoader> createState() => _BrandedLogoLoaderState();
}

class _BrandedLogoLoaderState extends State<BrandedLogoLoader>
    with TickerProviderStateMixin {
  AnimationController? _entryController;
  late final AnimationController _glowController;

  Animation<double>? _logoFade;
  Animation<double>? _logoScale;
  Animation<Offset>? _logoSlide;
  Animation<double>? _indicatorFade;

  @override
  void initState() {
    super.initState();

    if (widget.animate) {
      _entryController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
      );

      _logoFade = CurvedAnimation(
        parent: _entryController!,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      );

      _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _entryController!,
          curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
        ),
      );

      _logoSlide = Tween<Offset>(
        begin: const Offset(0, 0.08),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _entryController!,
          curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
        ),
      );

      _indicatorFade = CurvedAnimation(
        parent: _entryController!,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      );

      _entryController!.forward();
    }

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entryController?.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final containerSize = widget.logoSize * 1.5;
    final glowSize = widget.logoSize * (160 / 120);
    final borderRadius = widget.logoSize * (28 / 120);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([
            ?_entryController,
            _glowController,
          ]),
          builder: (context, child) {
            final glowOpacity =
                0.15 + 0.1 * math.sin(_glowController.value * math.pi);

            Widget logo = SizedBox(
              width: containerSize,
              height: containerSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: glowSize,
                    height: glowSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.accent.withValues(alpha: glowOpacity),
                          blurRadius: 60,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: widget.logoSize,
                      height: widget.logoSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            );

            if (widget.animate) {
              logo = FadeTransition(
                opacity: _logoFade!,
                child: SlideTransition(
                  position: _logoSlide!,
                  child: ScaleTransition(
                    scale: _logoScale!,
                    child: logo,
                  ),
                ),
              );
            }

            return logo;
          },
        ),
        if (widget.showProgressBar) ...[
          const SizedBox(height: 48),
          _buildProgressBar(),
        ],
      ],
    );
  }

  Widget _buildProgressBar() {
    final indicator = SizedBox(
      width: widget.logoSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1),
        child: LinearProgressIndicator(
          minHeight: 2,
          backgroundColor: AppColors.surfaceLight,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
        ),
      ),
    );

    if (widget.animate) {
      return FadeTransition(opacity: _indicatorFade!, child: indicator);
    }
    return indicator;
  }
}
