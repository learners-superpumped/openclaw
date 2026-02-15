import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../providers/api_provider.dart';
import '../providers/instance_provider.dart';
import '../providers/onboarding_provider.dart' show OnboardingStep, setupProgressProvider;
import '../theme/app_theme.dart';
import '../widgets/loading_button.dart';

class TelegramPairingScreen extends ConsumerStatefulWidget {
  const TelegramPairingScreen({super.key});

  @override
  ConsumerState<TelegramPairingScreen> createState() => _TelegramPairingScreenState();
}

class _TelegramPairingScreenState extends ConsumerState<TelegramPairingScreen> {
  final _codeController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;
  String? _botUsername;

  @override
  void initState() {
    super.initState();
    _fetchBotUsername();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _fetchBotUsername() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance;
      if (instance != null) {
        final status = await apiClient.getTelegramStatus(instance.instanceId, probe: true);
        final telegram = status['telegram'] as Map<String, dynamic>?;
        final probe = telegram?['probe'] as Map<String, dynamic>?;
        final bot = probe?['bot'] as Map<String, dynamic>?;
        final username = bot?['username'] as String?;
        if (mounted && username != null) {
          setState(() => _botUsername = username);
        }
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
        ref.read(setupProgressProvider.notifier).state = OnboardingStep.setupComplete;
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.telegramPairing,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.telegramPairingDesc,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (_botUsername != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _openBot,
              icon: const Icon(Icons.telegram),
              label: Text(AppLocalizations.of(context)!.openBotOnTelegram(_botUsername!)),
            ),
          ],
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  decoration: InputDecoration(hintText: AppLocalizations.of(context)!.authCode),
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
                label: Text(AppLocalizations.of(context)!.approve),
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
