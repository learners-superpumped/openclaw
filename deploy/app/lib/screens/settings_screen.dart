import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/instance_provider.dart';
import '../providers/onboarding_provider.dart';
import '../services/revenue_cat_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool? _telegramConnected;

  @override
  void initState() {
    super.initState();
    _loadTelegramStatus();
  }

  Future<void> _loadTelegramStatus() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance;
      if (instance != null) {
        final status = await apiClient.getTelegramStatus(instance.instanceId);
        if (mounted) {
          setState(() {
            _telegramConnected = status['connected'] == true;
          });
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SettingsTile(
            icon: Icons.credit_card_rounded,
            iconColor: AppColors.accent,
            title: AppLocalizations.of(context)!.manageSubscription,
            subtitle: AppLocalizations.of(context)!.manageSubscriptionDesc,
            onTap: () => RevenueCatService.showCustomerCenter(),
          ),
          if (_telegramConnected == false) ...[
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.telegram,
              iconColor: AppColors.accent,
              title: AppLocalizations.of(context)!.connectTelegram,
              subtitle: AppLocalizations.of(context)!.connectTelegramDesc,
              onTap: () {
                ref.read(setupProgressProvider.notifier).state = OnboardingStep.telegramSetup;
              },
            ),
          ],
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.restart_alt_rounded,
            iconColor: AppColors.error,
            title: AppLocalizations.of(context)!.recreateInstance,
            subtitle: AppLocalizations.of(context)!.recreateInstanceDesc,
            onTap: () => _showDeleteConfirmation(context),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.logout_rounded,
            iconColor: AppColors.error,
            title: AppLocalizations.of(context)!.logout,
            subtitle: AppLocalizations.of(context)!.logoutDesc,
            onTap: () => ref.read(authProvider.notifier).signOut(),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.person_remove_rounded,
            iconColor: AppColors.error,
            title: AppLocalizations.of(context)!.deleteAccount,
            subtitle: AppLocalizations.of(context)!.deleteAccountDesc,
            onTap: () => _showDeleteAccountConfirmation(context),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(AppLocalizations.of(context)!.recreateInstance),
        content: Text(
          AppLocalizations.of(context)!.recreateConfirmMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteInstance();
            },
            child: Text(
              AppLocalizations.of(context)!.recreate,
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteInstance() {
    ref.read(instanceProvider.notifier).deleteInstance();
    ref.read(setupProgressProvider.notifier).state = OnboardingStep.telegramSetup;
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(AppLocalizations.of(context)!.deleteAccountConfirmTitle),
        content: Text(
          AppLocalizations.of(context)!.deleteAccountConfirmMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).deleteAccount();
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
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
