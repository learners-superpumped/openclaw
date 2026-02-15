import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/instance_provider.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Map<String, dynamic>? _telegramStatus;
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
        final status = await apiClient.getTelegramStatus(instance.instanceId);
        if (mounted) setState(() => _telegramStatus = status);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final instanceState = ref.watch(instanceProvider);
    final instance = instanceState.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ClawBox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(instanceProvider.notifier).refresh();
              _loadStatus();
            },
          ),
        ],
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
            // Telegram status card
            Card(
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
                        if (_telegramStatus != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _telegramStatus!['connected'] == true
                                  ? AppColors.accentGreen.withValues(alpha: 0.15)
                                  : AppColors.textTertiary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _telegramStatus!['connected'] == true ? AppLocalizations.of(context)!.statusConnected : AppLocalizations.of(context)!.statusDisconnected,
                              style: TextStyle(
                                color: _telegramStatus!['connected'] == true
                                    ? AppColors.accentGreen
                                    : AppColors.textTertiary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (_telegramStatus != null && _telegramStatus!['botUsername'] != null) ...[
                      const SizedBox(height: 12),
                      _infoRow(AppLocalizations.of(context)!.labelBot, '@${_telegramStatus!['botUsername']}'),
                    ],
                  ],
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
