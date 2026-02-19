import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/instance_provider.dart';
import '../providers/onboarding_provider.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Map<String, dynamic>? _telegramStatus;
  String? _botUsername;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadStatus();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => _loadStatus());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadStatus() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance;
      if (instance != null) {
        final needProbe = _botUsername == null;
        final status = await apiClient.getTelegramStatus(
          instance.instanceId,
          probe: needProbe,
        );
        if (mounted) {
          setState(() {
            _telegramStatus = status;
            if (needProbe) {
              _botUsername = _extractBotUsername(status);
            }
          });
        }
      }
    } catch (_) {}
  }

  String? _extractBotUsername(Map<String, dynamic> status) {
    final telegram = status['telegram'] as Map<String, dynamic>?;
    final probe = telegram?['probe'] as Map<String, dynamic>?;
    final bot = probe?['bot'] as Map<String, dynamic>?;
    return bot?['username'] as String?;
  }

  Future<void> _openTelegramBot() async {
    if (_botUsername == null) return;
    final url = Uri.parse('https://t.me/$_botUsername');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final instanceState = ref.watch(instanceProvider);
    final instance = instanceState.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ClawBox'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(instanceProvider.notifier).refresh();
          await _loadStatus();
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // User card
            if (authState.user != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                        backgroundImage: authState.user!.avatarUrl != null
                            ? NetworkImage(authState.user!.avatarUrl!)
                            : null,
                        child: authState.user!.avatarUrl == null
                            ? Icon(Icons.person, color: AppColors.accent)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authState.user!.name ?? authState.user!.email,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              authState.user!.email,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Instance card
            if (instance != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.dns_outlined, color: AppColors.accent, size: 20),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.instance, style: Theme.of(context).textTheme.titleMedium),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: instance.isReady
                                  ? AppColors.accentGreen.withValues(alpha: 0.15)
                                  : AppColors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              instance.isReady ? AppLocalizations.of(context)!.statusRunning : (instance.manager?.phase ?? AppLocalizations.of(context)!.statusWaiting),
                              style: TextStyle(
                                color: instance.isReady ? AppColors.accentGreen : AppColors.warning,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _infoRow(AppLocalizations.of(context)!.labelId, instance.instanceId),
                      if (instance.displayName != null)
                        _infoRow(AppLocalizations.of(context)!.labelName, instance.displayName!),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Chat CTA card
            if (instance != null)
              Card(
                clipBehavior: Clip.antiAlias,
                color: AppColors.accent.withValues(alpha: 0.06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.accent.withValues(alpha: 0.25)),
                ),
                child: InkWell(
                  onTap: () => context.push('/dashboard/chat'),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.chat_rounded,
                            color: AppColors.accent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chat with AI',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                instance.isReady
                                    ? 'Your agent is ready'
                                    : 'Agent is starting up...',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: instance.isReady
                                      ? AppColors.accentGreen
                                      : AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.accent.withValues(alpha: 0.7),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Telegram card (unified)
            if (_telegramStatus != null && _telegramStatus!['connected'] == true)
              Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _botUsername != null ? _openTelegramBot : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.telegram, color: AppColors.accent, size: 20),
                            const SizedBox(width: 8),
                            Text('Telegram', style: Theme.of(context).textTheme.titleMedium),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accentGreen.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.statusConnected,
                                style: TextStyle(
                                  color: AppColors.accentGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_botUsername != null) ...[
                          const SizedBox(height: 12),
                          _infoRow(AppLocalizations.of(context)!.labelBot, '@$_botUsername'),
                        ],
                      ],
                    ),
                  ),
                ),
              )
            else if (_telegramStatus != null)
              Card(
                clipBehavior: Clip.antiAlias,
                color: AppColors.accentGreen.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.accentGreen.withValues(alpha: 0.3)),
                ),
                child: InkWell(
                  onTap: () {
                    ref.read(setupProgressProvider.notifier).state = OnboardingStep.telegramSetup;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(Icons.telegram, color: AppColors.accent, size: 32),
                            Positioned(
                              right: -4,
                              bottom: -4,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.surface, width: 2),
                                ),
                                child: const Icon(Icons.priority_high, color: Colors.white, size: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.connectTelegram,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppLocalizations.of(context)!.connectTelegramDesc,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: TextStyle(color: AppColors.textTertiary, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}
