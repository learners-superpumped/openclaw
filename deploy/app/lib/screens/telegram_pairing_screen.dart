import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../providers/api_provider.dart';
import '../providers/instance_provider.dart';
import '../providers/onboarding_provider.dart' show OnboardingStep, setupProgressProvider;
import '../theme/app_theme.dart';
import '../widgets/branded_logo_loader.dart';
import '../widgets/loading_button.dart';

class TelegramPairingScreen extends ConsumerStatefulWidget {
  final VoidCallback? onPairingComplete;

  const TelegramPairingScreen({super.key, this.onPairingComplete});

  @override
  ConsumerState<TelegramPairingScreen> createState() => _TelegramPairingScreenState();
}

class _TelegramPairingScreenState extends ConsumerState<TelegramPairingScreen> {
  final _codeController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;
  String? _botUsername;
  bool _botReady = false;
  List<Map<String, dynamic>> _pendingCodes = [];
  Timer? _botPollTimer;
  Timer? _codesPollTimer;

  @override
  void initState() {
    super.initState();
    _startBotPolling();
  }

  @override
  void dispose() {
    _botPollTimer?.cancel();
    _codesPollTimer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _startBotPolling() {
    _pollBotStatus();
    _botPollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _pollBotStatus());
  }

  Future<void> _pollBotStatus() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance;
      if (instance == null) return;
      final status = await apiClient.getTelegramStatus(instance.instanceId, probe: true);
      final telegram = status['telegram'] as Map<String, dynamic>?;
      final probe = telegram?['probe'] as Map<String, dynamic>?;
      final bot = probe?['bot'] as Map<String, dynamic>?;
      final username = bot?['username'] as String?;
      if (mounted && username != null) {
        _botPollTimer?.cancel();
        setState(() {
          _botUsername = username;
          _botReady = true;
        });
        _startCodePolling();
      }
    } catch (_) {}
  }

  void _startCodePolling() {
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

  Future<void> _openBot() async {
    if (_botUsername == null) return;
    final url = Uri.parse('https://t.me/$_botUsername');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _approve(String code) async {
    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance!;
      await apiClient.approvePairing(instance.instanceId, 'telegram', code);
      if (mounted) {
        _codesPollTimer?.cancel();
        if (widget.onPairingComplete != null) {
          widget.onPairingComplete!();
        } else {
          ref.read(setupProgressProvider.notifier).state = OnboardingStep.setupComplete;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context)!.pairingError;
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_botReady) {
      return _buildLoadingState();
    }
    return _buildPairingState();
  }

  Widget _buildLoadingState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BrandedLogoLoader(animate: true, showProgressBar: true),
          const SizedBox(height: 32),
          Text(
            l10n.connectingBot,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.connectingBotDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPairingState() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            l10n.telegramPairing,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.telegramPairingDesc,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (_botUsername != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _openBot,
              icon: const Icon(Icons.telegram),
              label: Text(l10n.openBotOnTelegram(_botUsername!)),
            ),
          ],
          const SizedBox(height: 32),
          Text(
            l10n.pendingPairingCodes,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          if (_pendingCodes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.noPendingCodes,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...List.generate(_pendingCodes.length, (i) {
              final item = _pendingCodes[i];
              final code = item['code'] as String? ?? '';
              return Padding(
                padding: EdgeInsets.only(bottom: i < _pendingCodes.length - 1 ? 8 : 0),
                child: Material(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _isSubmitting ? null : () => _approve(code),
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
                          Text(
                            l10n.tapToApprove,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.accent,
                                ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right, size: 18, color: AppColors.accent),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  decoration: InputDecoration(hintText: l10n.authCode),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 12),
              LoadingButton(
                onPressed: () {
                  final code = _codeController.text.trim();
                  if (code.isNotEmpty) _approve(code);
                },
                isLoading: _isSubmitting,
                minimumSize: const Size(80, 52),
                label: Text(l10n.approve),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: AppColors.error, fontSize: 13)),
          ],
        ],
      ),
    );
  }
}
