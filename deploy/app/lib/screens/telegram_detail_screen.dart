import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../providers/api_provider.dart';
import '../providers/channel_provider.dart';
import '../providers/instance_provider.dart';
import '../theme/app_theme.dart';

class TelegramDetailScreen extends ConsumerStatefulWidget {
  const TelegramDetailScreen({super.key});

  @override
  ConsumerState<TelegramDetailScreen> createState() =>
      _TelegramDetailScreenState();
}

class _TelegramDetailScreenState extends ConsumerState<TelegramDetailScreen> {
  bool _isConnected = false;
  String? _botUsername;
  List<Map<String, dynamic>> _pendingCodes = [];
  Timer? _pollTimer;
  String? _approvingCode;
  bool _isDisconnecting = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    ref.read(analyticsProvider).logChannelDetailViewed(channel: 'telegram');
    _loadStatus();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadStatus() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance;
      if (instance == null) return;

      final status = await apiClient.getTelegramStatus(
        instance.instanceId,
        probe: true,
      );
      final connected = status['connected'] == true;
      String? username;
      if (connected) {
        final telegram = status['telegram'] as Map<String, dynamic>?;
        final probe = telegram?['probe'] as Map<String, dynamic>?;
        final bot = probe?['bot'] as Map<String, dynamic>?;
        username = bot?['username'] as String?;
      }

      if (mounted) {
        setState(() {
          _isConnected = connected;
          _botUsername = username;
          _isLoading = false;
        });
        if (connected) {
          _startCodePolling();
        }
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startCodePolling() {
    _pollTimer?.cancel();
    _pollPendingCodes();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _pollPendingCodes(),
    );
  }

  Future<void> _pollPendingCodes() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance;
      if (instance == null) return;
      final codes = await apiClient.listPairing(
        instance.instanceId,
        'telegram',
      );
      if (mounted) setState(() => _pendingCodes = codes);
    } catch (_) {}
  }

  Future<void> _openTelegramBot() async {
    if (_botUsername == null) return;
    final url = Uri.parse('https://t.me/$_botUsername');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _approvePairing(String code) async {
    setState(() => _approvingCode = code);
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance!;
      await apiClient.approvePairing(instance.instanceId, 'telegram', code);
      ref.read(analyticsProvider).logPairingApproved(channel: 'telegram');
      if (mounted) {
        setState(() {
          _pendingCodes.removeWhere((c) => c['code'] == code);
          _approvingCode = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pairingApproved),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _approvingCode = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.pairingError)),
        );
      }
    }
  }

  Future<void> _disconnect() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(l10n.disconnectConfirmTitle),
        content: Text(l10n.disconnectConfirmMessage),
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
              l10n.disconnectChannel,
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isDisconnecting = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance!;
      await apiClient.logoutTelegram(instance.instanceId);
      ref.read(analyticsProvider).logChannelDisconnected(channel: 'telegram');
      ref.read(channelProvider.notifier).loadAll();
      if (mounted) {
        setState(() {
          _isConnected = false;
          _botUsername = null;
          _pendingCodes = [];
          _isDisconnecting = false;
        });
        _pollTimer?.cancel();
      }
    } catch (_) {
      if (mounted) setState(() => _isDisconnecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: const Text('Telegram')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatus,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Status card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF26A5E4,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.telegram,
                              color: Color(0xFF26A5E4),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Telegram',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: _isConnected
                                            ? AppColors.accentGreen
                                            : AppColors.textTertiary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      _isConnected
                                          ? l10n.channelConnected
                                          : l10n.channelDisconnected,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: _isConnected
                                                ? AppColors.accentGreen
                                                : AppColors.textTertiary,
                                          ),
                                    ),
                                    if (_botUsername != null) ...[
                                      const SizedBox(width: 6),
                                      Text(
                                        '@$_botUsername',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 11),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_isConnected) ...[
                    // Open in Telegram button
                    if (_botUsername != null)
                      OutlinedButton.icon(
                        onPressed: _openTelegramBot,
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: Text(l10n.openBotOnTelegram(_botUsername!)),
                      ),
                    const SizedBox(height: 20),

                    // Pending pairing codes
                    if (_pendingCodes.isNotEmpty) ...[
                      Text(
                        l10n.pendingPairingCodes,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
                      ..._pendingCodes.map((item) {
                        final code = item['code'] as String? ?? '';
                        final isApproving = _approvingCode == code;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 4,
                              bottom: 4,
                              right: 4,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    code,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      letterSpacing: 2,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                                if (isApproving)
                                  const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  )
                                else
                                  IconButton(
                                    onPressed: () => _approvePairing(code),
                                    icon: const Icon(
                                      Icons.check_rounded,
                                      size: 18,
                                    ),
                                    style: IconButton.styleFrom(
                                      foregroundColor: AppColors.accent,
                                      backgroundColor: AppColors.accent
                                          .withValues(alpha: 0.1),
                                      minimumSize: const Size(36, 36),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    tooltip: l10n.approve,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],

                    // Disconnect button
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _isDisconnecting ? null : _disconnect,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      child: _isDisconnecting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.error,
                              ),
                            )
                          : Text(l10n.disconnectChannel),
                    ),
                  ] else ...[
                    // Connect Telegram CTA
                    FilledButton.icon(
                      onPressed: () async {
                        await context.push(
                          '/dashboard/channels/telegram/setup',
                        );
                        if (mounted) _loadStatus();
                      },
                      icon: const Icon(Icons.telegram),
                      label: Text(l10n.connectTelegram),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
