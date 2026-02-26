import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/subscription_provider.dart';
import '../services/api_client.dart';
import '../services/revenue_cat_service.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 720;

    return Scaffold(
      body: isWide
          ? _WidePaywall(ref: ref)
          : _NarrowPaywall(ref: ref),
    );
  }

  static void showReferralCodeDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    final apiClient = ref.read(apiClientProvider);
    final subNotifier = ref.read(isProProvider.notifier);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return _ReferralCodeSheet(
          controller: controller,
          l10n: l10n,
          apiClient: apiClient,
          subNotifier: subNotifier,
          parentContext: context,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Narrow (mobile) layout — original vertical layout
// ---------------------------------------------------------------------------
class _NarrowPaywall extends ConsumerWidget {
  final WidgetRef ref;
  const _NarrowPaywall({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/images/logo.png', width: 80, height: 80),
            ),
            const SizedBox(height: 32),
            Text('ClawBox', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 12),
            Text(
              l10n.tagline,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
            FilledButton(
              onPressed: () async {
                HapticFeedback.lightImpact();
                await RevenueCatService.showPaywall(context: context);
                ref.read(isProProvider.notifier).refresh();
              },
              child: Text(l10n.getStarted),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                RevenueCatService.showCustomerCenter();
              },
              child: Text(
                l10n.alreadySubscribed,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                PaywallScreen.showReferralCodeDialog(context, ref);
              },
              child: Text(
                l10n.haveReferralCode,
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                ref.read(authProvider.notifier).signOut();
              },
              child: Text(
                l10n.logout,
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Wide (tablet / desktop) layout — two-column split
// ---------------------------------------------------------------------------
class _WidePaywall extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _WidePaywall({required this.ref});

  @override
  ConsumerState<_WidePaywall> createState() => _WidePaywallState();
}

class _WidePaywallState extends ConsumerState<_WidePaywall>
    with TickerProviderStateMixin {
  late final AnimationController _orbController;
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _orbController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1080;

    return FadeTransition(
      opacity: CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
      child: Row(
        children: [
          // ---- Left panel: brand showcase ----
          Expanded(
            flex: isDesktop ? 5 : 4,
            child: _LeftPanel(
              orbController: _orbController,
              l10n: l10n,
            ),
          ),

          // ---- Right panel: actions ----
          Expanded(
            flex: isDesktop ? 4 : 5,
            child: _RightPanel(l10n: l10n, ref: ref),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Left panel — brand, features, animated orbs
// ---------------------------------------------------------------------------
class _LeftPanel extends StatelessWidget {
  final AnimationController orbController;
  final AppLocalizations l10n;

  const _LeftPanel({required this.orbController, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF050508),
      ),
      child: Stack(
        children: [
          // Animated gradient orbs
          AnimatedBuilder(
            animation: orbController,
            builder: (context, child) {
              final t = orbController.value;
              return Stack(
                children: [
                  Positioned(
                    left: -60 + 40 * math.sin(t * math.pi),
                    top: -40 + 30 * math.cos(t * math.pi * 0.7),
                    child: _GlowOrb(
                      size: 320,
                      color: GlassColors.orbCyan.withValues(alpha: 0.12),
                    ),
                  ),
                  Positioned(
                    right: -80 + 50 * math.cos(t * math.pi * 1.3),
                    bottom: -60 + 40 * math.sin(t * math.pi * 0.5),
                    child: _GlowOrb(
                      size: 280,
                      color: GlassColors.orbPurple.withValues(alpha: 0.10),
                    ),
                  ),
                  Positioned(
                    right: 60 + 30 * math.sin(t * math.pi * 0.9),
                    top: 100 + 20 * math.cos(t * math.pi * 1.1),
                    child: _GlowOrb(
                      size: 180,
                      color: GlassColors.orbTeal.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              );
            },
          ),

          // Subtle noise overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo + name
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 48,
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'ClawBox',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  const Spacer(flex: 2),

                  // Headline
                  Text(
                    l10n.paywallTitle,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -1.0,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.tagline,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Feature cards
                  _FeatureRow(
                    icon: Icons.telegram,
                    text: l10n.paywallFeature1,
                  ),
                  const SizedBox(height: 16),
                  _FeatureRow(
                    icon: Icons.bolt_rounded,
                    text: l10n.paywallFeature2,
                  ),
                  const SizedBox(height: 16),
                  _FeatureRow(
                    icon: Icons.touch_app_rounded,
                    text: l10n.paywallFeature3,
                  ),
                  const Spacer(flex: 2),

                  // Testimonial
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: GlassColors.glassSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: GlassColors.glassBorder,
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (_) => const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFFFD700),
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '"${l10n.paywallReview}"',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '— ${l10n.paywallReviewAuthor}',
                              style: const TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Right panel — CTA, actions, links
// ---------------------------------------------------------------------------
class _RightPanel extends ConsumerWidget {
  final AppLocalizations l10n;
  final WidgetRef ref;

  const _RightPanel({required this.l10n, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section header
                  Text(
                    l10n.getStarted,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.tagline,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Primary CTA
                  _PrimaryCta(
                    label: l10n.getStarted,
                    onPressed: () async {
                      await RevenueCatService.showPaywall(context: context);
                      ref.read(isProProvider.notifier).refresh();
                    },
                  ),
                  const SizedBox(height: 20),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.orDivider,
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Secondary actions
                  _SecondaryAction(
                    icon: Icons.refresh_rounded,
                    label: l10n.alreadySubscribed,
                    onTap: () => RevenueCatService.showCustomerCenter(),
                  ),
                  const SizedBox(height: 12),
                  _SecondaryAction(
                    icon: Icons.card_giftcard_rounded,
                    label: l10n.haveReferralCode,
                    onTap: () => PaywallScreen.showReferralCodeDialog(context, ref),
                  ),
                  const SizedBox(height: 12),
                  _SecondaryAction(
                    icon: Icons.logout_rounded,
                    label: l10n.logout,
                    onTap: () => ref.read(authProvider.notifier).signOut(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared sub-widgets
// ---------------------------------------------------------------------------

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: GlassColors.glassSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GlassColors.glassBorder, width: 0.5),
          ),
          child: Icon(icon, color: AppColors.accent, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryCta extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryCta({required this.label, required this.onPressed});

  @override
  State<_PrimaryCta> createState() => _PrimaryCtaState();
}

class _PrimaryCtaState extends State<_PrimaryCta> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onPressed();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          height: 56,
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.9)
                : AppColors.accent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: _hovered ? 0.35 : 0.2),
                blurRadius: _hovered ? 24 : 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppColors.background,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(left: _hovered ? 4 : 0),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.background,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SecondaryAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SecondaryAction> createState() => _SecondaryActionState();
}

class _SecondaryActionState extends State<_SecondaryAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceLight : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? AppColors.border.withValues(alpha: 0.6)
                  : AppColors.border.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Referral code bottom sheet (unchanged)
// ---------------------------------------------------------------------------
class _ReferralCodeSheet extends StatefulWidget {
  final TextEditingController controller;
  final AppLocalizations l10n;
  final ApiClient apiClient;
  final SubscriptionNotifier subNotifier;
  final BuildContext parentContext;

  const _ReferralCodeSheet({
    required this.controller,
    required this.l10n,
    required this.apiClient,
    required this.subNotifier,
    required this.parentContext,
  });

  @override
  State<_ReferralCodeSheet> createState() => _ReferralCodeSheetState();
}

class _ReferralCodeSheetState extends State<_ReferralCodeSheet> {
  bool _isLoading = false;

  Future<void> _submit() async {
    final code = widget.controller.text.trim();
    if (code.isEmpty || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final valid = await widget.apiClient.validateReferral(code);
      if (!mounted) return;
      Navigator.of(context).pop();

      if (valid) {
        await widget.subNotifier.activateReferral(code);
        if (!widget.parentContext.mounted) return;
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(content: Text(widget.l10n.referralCodeSuccess)),
        );
      } else {
        if (!widget.parentContext.mounted) return;
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(content: Text(widget.l10n.referralCodeInvalid)),
        );
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
      if (!widget.parentContext.mounted) return;
      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
        SnackBar(content: Text(widget.l10n.referralCodeInvalid)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.l10n.enterReferralCode,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: widget.controller,
            textCapitalization: TextCapitalization.characters,
            autofocus: true,
            decoration: InputDecoration(hintText: widget.l10n.referralCodeHint),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _isLoading ? null : () {
              HapticFeedback.lightImpact();
              _submit();
            },
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.l10n.approve),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: Text(
              widget.l10n.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

