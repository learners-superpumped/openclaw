import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/instance_provider.dart';
import '../providers/onboarding_provider.dart';
import '../services/revenue_cat_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_consent_sheet.dart';

const _kTelegramSetupSkipped = 'telegram_setup_skipped';
const _kAiDataConsentAccepted = 'ai_data_consent_v2';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool? _telegramConnected;
  bool _aiConsentEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadTelegramStatus();
    _loadAiConsentStatus();
  }

  Future<void> _loadAiConsentStatus() async {
    final storage = ref.read(secureStorageProvider);
    final consent = await storage.read(key: _kAiDataConsentAccepted);
    if (mounted) {
      setState(() {
        _aiConsentEnabled = consent == 'true';
      });
    }
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // General section
          _SectionHeader(title: l10n.general),
          _SettingsGroup(
            children: [
              _SettingsItem(
                icon: Icons.credit_card_rounded,
                title: l10n.manageSubscription,
                onTap: () => RevenueCatService.showCustomerCenter(),
              ),
              if (_telegramConnected == false)
                _SettingsItem(
                  icon: Icons.telegram,
                  title: l10n.connectTelegram,
                  onTap: () async {
                    await context.push('/dashboard/connect-telegram');
                    if (mounted) _loadTelegramStatus();
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),

          // AI Data Processing section
          _SectionHeader(title: l10n.aiDataProcessing),
          _SettingsGroup(
            children: [
              _SettingsToggleItem(
                icon: Icons.shield_outlined,
                title: l10n.aiDataSharing,
                value: _aiConsentEnabled,
                onChanged: (value) => _handleAiConsentToggle(value),
              ),
              _SettingsItem(
                icon: Icons.dns_outlined,
                title: l10n.aiDataProviders,
                onTap: () => _showAiProvidersSheet(context),
              ),
              _SettingsItem(
                icon: Icons.delete_sweep_outlined,
                title: l10n.requestDataDeletion,
                onTap: () => launchUrl(
                  Uri.parse('mailto:admin@learners.company'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Legal section
          _SectionHeader(title: l10n.legal),
          _SettingsGroup(
            children: [
              _SettingsItem(
                icon: Icons.description_outlined,
                title: l10n.termsOfService,
                onTap: () => launchUrl(
                  Uri.parse('$apiBaseUrl/legal/terms'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              _SettingsItem(
                icon: Icons.privacy_tip_outlined,
                title: l10n.privacyPolicy,
                onTap: () => launchUrl(
                  Uri.parse('$apiBaseUrl/legal/privacy'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Account section
          _SectionHeader(title: l10n.account),
          _SettingsGroup(
            children: [
              _SettingsItem(
                icon: Icons.restart_alt_rounded,
                title: l10n.recreateInstance,
                destructive: true,
                onTap: () => _showDeleteConfirmation(context),
              ),
              _SettingsItem(
                icon: Icons.logout_rounded,
                title: l10n.logout,
                destructive: true,
                onTap: () => ref.read(authProvider.notifier).signOut(),
              ),
              _SettingsItem(
                icon: Icons.person_remove_rounded,
                title: l10n.deleteAccount,
                destructive: true,
                onTap: () => _showDeleteAccountConfirmation(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleAiConsentToggle(bool value) async {
    final storage = ref.read(secureStorageProvider);
    if (!value) {
      // Revoking consent
      final l10n = AppLocalizations.of(context)!;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          title: Text(l10n.revokeAiConsentTitle),
          content: Text(l10n.revokeAiConsentMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                l10n.cancel,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                l10n.revoke,
                style: TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        await storage.delete(key: _kAiDataConsentAccepted);
        ref.read(aiDisclosureAcceptedProvider.notifier).state = false;
        if (mounted) setState(() => _aiConsentEnabled = false);
      }
    } else {
      // Re-granting consent via sheet
      if (!mounted) return;
      final agreed = await AiConsentSheet.show(context);
      if (agreed == true) {
        await storage.write(key: _kAiDataConsentAccepted, value: 'true');
        ref.read(aiDisclosureAcceptedProvider.notifier).state = true;
        if (mounted) setState(() => _aiConsentEnabled = true);
      }
    }
  }

  void _showAiProvidersSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
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
              l10n.aiDataProvidersTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.aiDataProvidersDesc,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _ProviderTile(
              name: 'OpenRouter',
              role: l10n.aiConsentRecipientOpenRouter,
            ),
            _ProviderTile(
              name: 'OpenAI',
              role: 'GPT models',
            ),
            _ProviderTile(
              name: 'Anthropic',
              role: 'Claude models',
            ),
            _ProviderTile(
              name: 'Google',
              role: 'Gemini models',
            ),
            const SizedBox(height: 16),
          ],
        ),
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
              style: TextStyle(
                  color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteInstance() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: _kTelegramSetupSkipped);
    ref.read(instanceProvider.notifier).deleteInstance();
    ref.read(setupProgressProvider.notifier).state =
        OnboardingStep.telegramSetup;
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
              style: TextStyle(
                  color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              fontSize: 11,
            ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final filtered = children
        .where((w) => w is _SettingsItem || w is _SettingsToggleItem)
        .toList();
    if (filtered.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          for (int i = 0; i < filtered.length; i++) ...[
            filtered[i],
            if (i < filtered.length - 1)
              const Divider(height: 1, indent: 48, endIndent: 0),
          ],
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool destructive;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.destructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.error : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.accent,
          ),
        ],
      ),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  final String name;
  final String role;

  const _ProviderTile({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                name[0],
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  role,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
