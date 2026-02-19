import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../providers/api_provider.dart';
import '../providers/instance_provider.dart';
import '../providers/onboarding_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_button.dart';

const _kTelegramSetupSkipped = 'telegram_setup_skipped';

class TelegramSetupScreen extends ConsumerStatefulWidget {
  final VoidCallback? onTokenSubmitted;
  final VoidCallback? onSkipped;

  const TelegramSetupScreen({
    super.key,
    this.onTokenSubmitted,
    this.onSkipped,
  });

  @override
  ConsumerState<TelegramSetupScreen> createState() => _TelegramSetupScreenState();
}

class _TelegramSetupScreenState extends ConsumerState<TelegramSetupScreen> {
  final _tokenController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance!;
      await apiClient.setupTelegram(instance.instanceId, token);
      if (mounted) {
        if (widget.onTokenSubmitted != null) {
          widget.onTokenSubmitted!();
        } else {
          ref.read(setupProgressProvider.notifier).state = OnboardingStep.telegramPairing;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context)!.botTokenError;
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
            AppLocalizations.of(context)!.telegramBotSetup,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.telegramBotSetupDesc,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          // Guide steps
          _buildStep(context, '1', AppLocalizations.of(context)!.stepSearchBotFather),
          _buildStep(context, '2', AppLocalizations.of(context)!.stepNewBot),
          _buildStep(context, '3', AppLocalizations.of(context)!.stepSetBotName),
          _buildStep(context, '4', AppLocalizations.of(context)!.stepEnterToken),
          const SizedBox(height: 32),
          TextField(
            controller: _tokenController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enterBotToken,
              prefixIcon: Icon(Icons.key, color: AppColors.textTertiary),
            ),
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: AppColors.error, fontSize: 13)),
          ],
          const SizedBox(height: 24),
          LoadingButton(
            onPressed: _submit,
            isLoading: _isSubmitting,
            label: Text(AppLocalizations.of(context)!.next),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => _showSkipDialog(context),
              child: Text(
                AppLocalizations.of(context)!.skip,
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSkipDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(AppLocalizations.of(context)!.skipTelegramTitle),
        content: Text(AppLocalizations.of(context)!.skipTelegramDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              if (widget.onSkipped != null) {
                widget.onSkipped!();
              } else {
                final storage = ref.read(secureStorageProvider);
                await storage.write(key: _kTelegramSetupSkipped, value: 'true');
                ref.read(setupProgressProvider.notifier).state = OnboardingStep.dashboard;
              }
            },
            child: Text(
              AppLocalizations.of(context)!.skip,
              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withValues(alpha: 0.15),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
