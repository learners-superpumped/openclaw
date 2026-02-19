import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_provider.dart';
import '../providers/subscription_provider.dart';
import '../services/api_client.dart';
import '../services/revenue_cat_service.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
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
              Text(
                'ClawBox',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.tagline,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              FilledButton(
                onPressed: () async {
                  await RevenueCatService.showPaywall();
                  ref.read(isProProvider.notifier).refresh();
                },
                child: Text(AppLocalizations.of(context)!.getStarted),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => RevenueCatService.showCustomerCenter(),
                child: Text(
                  AppLocalizations.of(context)!.alreadySubscribed,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _showReferralCodeDialog(context, ref),
                child: Text(
                  AppLocalizations.of(context)!.haveReferralCode,
                  style: TextStyle(color: AppColors.textTertiary),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showReferralCodeDialog(BuildContext context, WidgetRef ref) {
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
            onPressed: _isLoading ? null : _submit,
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
