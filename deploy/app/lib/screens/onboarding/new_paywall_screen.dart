import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../services/api_client.dart';

enum _PlanType { weekly, monthly }

class NewPaywallScreen extends ConsumerStatefulWidget {
  const NewPaywallScreen({super.key});

  @override
  ConsumerState<NewPaywallScreen> createState() => _NewPaywallScreenState();
}

class _NewPaywallScreenState extends ConsumerState<NewPaywallScreen> {
  _PlanType _selectedPlan = _PlanType.monthly; // ignore: prefer_final_fields
  bool _isPurchasing = false;

  Package? _getPackage(
    PackageType type,
    AsyncValue<Offerings?> offeringsAsync,
  ) {
    return offeringsAsync.valueOrNull?.current?.availablePackages
        .where((p) => p.packageType == type)
        .firstOrNull;
  }

  Future<void> _purchase() async {
    if (_isPurchasing) return;
    final offeringsAsync = ref.read(offeringsProvider);
    final package = _selectedPlan == _PlanType.weekly
        ? _getPackage(PackageType.weekly, offeringsAsync)
        : _getPackage(PackageType.monthly, offeringsAsync);
    if (package == null) return;

    setState(() => _isPurchasing = true);
    try {
      HapticFeedback.mediumImpact();
      final params = PurchaseParams.package(package);
      await Purchases.purchase(params);
      ref.read(isProProvider.notifier).refresh();
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('Purchase error: $errorCode');
      }
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  Future<void> _restore() async {
    HapticFeedback.lightImpact();
    try {
      await Purchases.restorePurchases();
      ref.read(isProProvider.notifier).refresh();
    } catch (e) {
      debugPrint('[Restore] error: $e');
    }
  }

  void _showReferralDialog() {
    HapticFeedback.lightImpact();
    final controller = TextEditingController();
    final apiClient = ref.read(apiClientProvider);
    final subNotifier = ref.read(isProProvider.notifier);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141415),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return _ReferralCodeSheet(
          controller: controller,
          apiClient: apiClient,
          subNotifier: subNotifier,
          parentContext: context,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          l10n.onboardingBadgeTopApp,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.newPaywallTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEAEAEB),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.newPaywallSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8A8B8D),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Benefits
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        _benefitRow(l10n.newPaywallBenefit1),
                        const SizedBox(height: 8),
                        _benefitRow(l10n.newPaywallBenefit2),
                        const SizedBox(height: 8),
                        _benefitRow(l10n.newPaywallBenefit3),
                      ],
                    ),
                  ),

                  // Q&A section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.newPaywallFaqPriceQuestion,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEAEAEB),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.newPaywallFaqPriceAnswer,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8A8B8D),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.newPaywallFaqCheaperQuestion,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEAEAEB),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.newPaywallFaqCheaperAnswer,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8A8B8D),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pricing cards
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Builder(
                      builder: (context) {
                        final offeringsAsync = ref.watch(offeringsProvider);
                        final isLoading = offeringsAsync.isLoading;
                        final weeklyPrice =
                            _getPackage(
                              PackageType.weekly,
                              offeringsAsync,
                            )?.storeProduct.priceString ??
                            '\$19.99';
                        final monthlyPrice =
                            _getPackage(
                              PackageType.monthly,
                              offeringsAsync,
                            )?.storeProduct.priceString ??
                            '\$79.99';

                        return Skeletonizer(
                          ignoreContainers: true,
                          enabled: isLoading,
                          effect: ShimmerEffect(
                            baseColor: const Color(0xFF1F2023),
                            highlightColor: const Color(0xFF2A2A2D),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildPlanCard(
                                  l10n: l10n,
                                  plan: _PlanType.weekly,
                                  price: weeklyPrice,
                                  period: l10n.newPaywallPeriodWeek,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildPlanCard(
                                  l10n: l10n,
                                  plan: _PlanType.monthly,
                                  price: monthlyPrice,
                                  period: l10n.newPaywallPeriodMonth,
                                  bestValue: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // CTA area
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
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
                            onPressed: _isPurchasing ? null : _purchase,
                            child: _isPurchasing
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(l10n.newPaywallStartNowButton),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            TextButton(
                              onPressed: _restore,
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF6B7280),
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                minimumSize: const Size(0, 36),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(l10n.newPaywallRestorePurchase),
                            ),
                            Text(
                              '·',
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                            TextButton(
                              onPressed: _showReferralDialog,
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF6B7280),
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                minimumSize: const Size(0, 36),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(l10n.newPaywallHaveReferralCode),
                            ),
                            Text(
                              '·',
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                ref.read(authProvider.notifier).signOut();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF6B7280),
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                minimumSize: const Size(0, 36),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(l10n.commonLogout),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Social proof
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.newPaywallSocialProof,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEAEAEB),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Press logos
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: 0.6,
                              child: Image.asset(
                                'assets/images/onboarding/bloomberg-w.png',
                                width: 56,
                                height: 16,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Opacity(
                              opacity: 0.6,
                              child: Image.asset(
                                'assets/images/onboarding/cnbc-w.png',
                                width: 40,
                                height: 16,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Opacity(
                              opacity: 0.6,
                              child: Image.asset(
                                'assets/images/onboarding/cnn-w.png',
                                width: 40,
                                height: 16,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Opacity(
                              opacity: 0.6,
                              child: Image.asset(
                                'assets/images/onboarding/fortune-w.png',
                                width: 48,
                                height: 16,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Opacity(
                              opacity: 0.6,
                              child: Image.asset(
                                'assets/images/onboarding/techcrunch-w.png',
                                width: 40,
                                height: 16,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // LLM icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/images/onboarding/openai-icon.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/images/onboarding/anthropic-icon.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/images/onboarding/gemini-icon.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/images/onboarding/mistral-icon.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/images/onboarding/deepseek-icon.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required AppLocalizations l10n,
    required _PlanType plan,
    required String price,
    required String period,
    bool bestValue = false, // ignore: unused_element_parameter
  }) {
    final isSelected = _selectedPlan == plan;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = plan),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isSelected ? 20 : 14,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF141415),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF1F2023),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // BEST VALUE badge
              if (bestValue)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.newPaywallBestValueBadge,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              Text(
                price,
                style: TextStyle(
                  fontSize: isSelected ? 28 : 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEAEAEB),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                period,
                style: const TextStyle(fontSize: 12, color: Color(0xFF8A8B8D)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _benefitRow(String text) {
    return Row(
      children: [
        const Icon(LucideIcons.check, size: 16, color: Color(0xFF3B82F6)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFFEAEAEB)),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Referral code bottom sheet
// ---------------------------------------------------------------------------
class _ReferralCodeSheet extends StatefulWidget {
  final TextEditingController controller;
  final ApiClient apiClient;
  final SubscriptionNotifier subNotifier;
  final BuildContext parentContext;

  const _ReferralCodeSheet({
    required this.controller,
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
        final l10n = AppLocalizations.of(widget.parentContext)!;
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(content: Text(l10n.newPaywallReferralAppliedSuccess)),
        );
      } else {
        if (!widget.parentContext.mounted) return;
        final l10n = AppLocalizations.of(widget.parentContext)!;
        ScaffoldMessenger.of(
          widget.parentContext,
        ).showSnackBar(SnackBar(content: Text(l10n.newPaywallReferralInvalid)));
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
      if (!widget.parentContext.mounted) return;
      final l10n = AppLocalizations.of(widget.parentContext)!;
      ScaffoldMessenger.of(
        widget.parentContext,
      ).showSnackBar(SnackBar(content: Text(l10n.newPaywallReferralInvalid)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              color: const Color(0xFF2E2E2E),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.newPaywallReferralSheetTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEAEAEB),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: widget.controller,
            textCapitalization: TextCapitalization.characters,
            autofocus: true,
            style: const TextStyle(color: Color(0xFFEAEAEB)),
            decoration: InputDecoration(
              hintText: l10n.newPaywallReferralHint,
              hintStyle: const TextStyle(color: Color(0xFF8A8B8D)),
              filled: true,
              fillColor: const Color(0xFF0A0A0B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF3B82F6)),
              ),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      _submit();
                    },
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.newPaywallReferralApplyButton),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Color(0xFF8A8B8D)),
            ),
          ),
        ],
      ),
    );
  }
}
