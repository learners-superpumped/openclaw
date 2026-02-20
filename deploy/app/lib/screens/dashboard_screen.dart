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

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver {
  Map<String, dynamic>? _telegramStatus;
  String? _botUsername;
  Timer? _refreshTimer;
  List<Map<String, dynamic>> _pendingCodes = [];
  Timer? _codesPollTimer;
  final Set<String> _dismissedCodes = {};
  String? _approvingCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadStatus();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => _loadStatus());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    _codesPollTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadStatus();
      if (_botUsername != null) {
        _pollPendingCodes();
      }
    }
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
          final hadBot = _botUsername != null;
          setState(() {
            _telegramStatus = status;
            if (needProbe) {
              _botUsername = _extractBotUsername(status);
            }
          });
          // Start code polling as soon as bot is configured
          if (_botUsername != null && (!hadBot || _codesPollTimer == null)) {
            _startCodePolling();
          }
        }
      }
    } catch (_) {}
  }

  void _startCodePolling() {
    _codesPollTimer?.cancel();
    _pollPendingCodes();
    _codesPollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _pollPendingCodes());
  }

  Future<void> _pollPendingCodes() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance;
      if (instance == null) return;
      final codes = await apiClient.listPairing(instance.instanceId, 'telegram');
      if (mounted) {
        setState(() => _pendingCodes = codes);
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

  Future<void> _approvePairing(String code) async {
    setState(() => _approvingCode = code);
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance!;
      await apiClient.approvePairing(instance.instanceId, 'telegram', code);
      if (mounted) {
        setState(() {
          _pendingCodes.removeWhere((c) => c['code'] == code);
          _approvingCode = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.pairingApproved)),
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

  void _dismissPairing(String code) {
    setState(() {
      _dismissedCodes.add(code);
      _pendingCodes.removeWhere((c) => c['code'] == code);
    });
  }

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 18) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  List<Map<String, dynamic>> get _visiblePendingCodes =>
      _pendingCodes.where((c) => !_dismissedCodes.contains(c['code'])).toList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final instanceState = ref.watch(instanceProvider);
    final instance = instanceState.instance;
    final user = authState.user;
    final isTelegramLoading = _telegramStatus == null;
    final isTelegramConnected = _telegramStatus != null && _telegramStatus!['connected'] == true;
    final visibleCodes = _visiblePendingCodes;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting(l10n),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (user != null)
              Text(
                user.name ?? user.email,
                style: Theme.of(context).textTheme.titleMedium,
              ),
          ],
        ),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Icon(Icons.person, color: AppColors.accent, size: 18)
                    : null,
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(instanceProvider.notifier).refresh();
          await _loadStatus();
          if (_botUsername != null) {
            await _pollPendingCodes();
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Chat CTA
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
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: AppColors.accent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.chatWithAI,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color: instance.isReady
                                          ? AppColors.accent
                                          : AppColors.textTertiary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    instance.isReady
                                        ? l10n.agentReady
                                        : l10n.agentStarting,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: instance.isReady
                                          ? AppColors.accent
                                          : AppColors.textTertiary,
                                    ),
                                  ),
                                ],
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
            // Status Bar — Instance + Telegram in a row
            if (instance != null)
              Row(
                children: [
                  Expanded(
                    child: _StatusTile(
                      icon: Icons.dns_outlined,
                      label: l10n.instance,
                      isActive: instance.isReady,
                      statusText: instance.isReady
                          ? l10n.statusRunning
                          : (instance.manager?.phase ?? l10n.statusWaiting),
                      subtitle: instance.displayName,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatusTile(
                      icon: Icons.telegram,
                      label: 'Telegram',
                      isLoading: isTelegramLoading,
                      isActive: isTelegramConnected,
                      statusText: isTelegramLoading
                          ? l10n.statusWaiting
                          : isTelegramConnected
                              ? l10n.statusConnected
                              : l10n.statusDisconnected,
                      subtitle: isTelegramConnected && _botUsername != null
                          ? '@$_botUsername'
                          : null,
                      onTap: isTelegramConnected && _botUsername != null
                          ? _openTelegramBot
                          : null,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            // Pending codes / pairing guide (bot configured) or Connect Telegram CTA (no bot)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _botUsername != null && visibleCodes.isNotEmpty
                  ? _buildPairingCard(l10n, visibleCodes)
                  : _telegramStatus != null && _botUsername == null
                      ? Card(
                          clipBehavior: Clip.antiAlias,
                          color: AppColors.accent.withValues(alpha: 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: AppColors.accent.withValues(alpha: 0.25)),
                          ),
                          child: InkWell(
                            onTap: () {
                              ref.read(setupProgressProvider.notifier).state = OnboardingStep.telegramSetup;
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  Icon(Icons.telegram, color: AppColors.accent, size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.connectTelegram,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          l10n.connectTelegramDesc,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textTertiary, size: 16),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPairingCard(AppLocalizations l10n, List<Map<String, dynamic>> codes) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: AppColors.accent.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.telegram, color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  codes.isEmpty ? l10n.telegramPairing : l10n.pendingPairingCodes,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (codes.isEmpty) ...[
              Text(
                l10n.noPendingCodes,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (_botUsername != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _openTelegramBot,
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: Text(l10n.openBotOnTelegram(_botUsername!)),
                ),
              ],
            ] else ...[
            ...codes.map((item) {
              final code = item['code'] as String? ?? '';
              final isApproving = _approvingCode == code;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: isApproving ? null : () => _approvePairing(code),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.vpn_key_rounded, size: 20, color: AppColors.accent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              code,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          if (isApproving)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
                            )
                          else ...[
                            Text(
                              l10n.approve,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right, size: 18, color: AppColors.accent),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _dismissPairing(code),
                              child: const Icon(Icons.close, size: 16, color: AppColors.textTertiary),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLoading;
  final bool isActive;
  final String statusText;
  final String? subtitle;
  final VoidCallback? onTap;

  const _StatusTile({
    required this.icon,
    required this.label,
    this.isLoading = false,
    required this.isActive,
    required this.statusText,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.textSecondary, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: AppColors.textTertiary,
                      ),
                    )
                  else
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.accent : AppColors.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: isLoading
                            ? AppColors.textTertiary
                            : isActive
                                ? AppColors.accent
                                : AppColors.textTertiary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
