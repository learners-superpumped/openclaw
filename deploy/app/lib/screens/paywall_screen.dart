import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/subscription_provider.dart';
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
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
