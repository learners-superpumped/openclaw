import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/instance_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/branded_logo_loader.dart';

class InstanceLoadingScreen extends ConsumerStatefulWidget {
  const InstanceLoadingScreen({super.key});

  @override
  ConsumerState<InstanceLoadingScreen> createState() => _InstanceLoadingScreenState();
}

class _InstanceLoadingScreenState extends ConsumerState<InstanceLoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(instanceProvider);
      if (state.status == InstanceStatus.idle || state.status == InstanceStatus.error) {
        ref.read(instanceProvider.notifier).ensureInstance();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(instanceProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state.status == InstanceStatus.error) ...[
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.instanceCreationFailed,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.checkNetworkAndRetry,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => ref.read(instanceProvider.notifier).ensureInstance(),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ] else ...[
            BrandedLogoLoader(),
            const SizedBox(height: 32),
            Text(
              _statusTitle(context, state.status),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _statusDescription(context, state.status),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (state.instance?.manager != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      state.instance!.manager!.phase,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  String _statusTitle(BuildContext context, InstanceStatus status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case InstanceStatus.creating:
        return l10n.creatingInstance;
      case InstanceStatus.polling:
        return l10n.settingUp;
      default:
        return l10n.preparing;
    }
  }

  String _statusDescription(BuildContext context, InstanceStatus status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case InstanceStatus.creating:
        return l10n.creatingInstanceDesc;
      case InstanceStatus.polling:
        return l10n.startingInstanceDesc;
      default:
        return l10n.pleaseWait;
    }
  }
}
