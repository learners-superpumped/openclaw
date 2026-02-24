import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../providers/api_provider.dart';
import '../providers/instance_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_button.dart';

class DiscordSetupScreen extends ConsumerStatefulWidget {
  final VoidCallback? onTokenSubmitted;

  const DiscordSetupScreen({
    super.key,
    this.onTokenSubmitted,
  });

  @override
  ConsumerState<DiscordSetupScreen> createState() => _DiscordSetupScreenState();
}

class _DiscordSetupScreenState extends ConsumerState<DiscordSetupScreen> {
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
      await apiClient.setupDiscord(instance.instanceId, token);
      if (mounted) {
        widget.onTokenSubmitted?.call();
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
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            l10n.discordBotSetup,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.discordBotSetupDesc,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          _buildStep(context, '1', l10n.stepCreateApp),
          _buildStep(context, '2', l10n.stepAddBot),
          _buildStep(context, '3', l10n.stepEnableIntents),
          _buildStep(context, '4', l10n.stepCopyToken),
          const SizedBox(height: 32),
          TextField(
            controller: _tokenController,
            decoration: InputDecoration(
              hintText: l10n.enterBotToken,
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
            label: Text(l10n.next),
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
