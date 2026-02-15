import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../providers/onboarding_provider.dart' show OnboardingStep, setupProgressProvider;
import '../theme/app_theme.dart';

class SetupCompleteScreen extends ConsumerWidget {
  const SetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.accentGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.setupCompleteTitle,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.setupCompleteDesc,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                ref.read(setupProgressProvider.notifier).state =
                    OnboardingStep.dashboard;
              },
              style: FilledButton.styleFrom(minimumSize: const Size(200, 52)),
              child: Text(AppLocalizations.of(context)!.startChatting),
            ),
          ],
        ),
      ),
    );
  }
}
