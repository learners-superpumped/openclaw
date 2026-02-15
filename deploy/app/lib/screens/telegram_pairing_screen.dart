import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_provider.dart';
import '../providers/instance_provider.dart';
import '../providers/onboarding_provider.dart' show OnboardingStep, setupProgressProvider;
import '../theme/app_theme.dart';

class TelegramPairingScreen extends ConsumerStatefulWidget {
  const TelegramPairingScreen({super.key});

  @override
  ConsumerState<TelegramPairingScreen> createState() => _TelegramPairingScreenState();
}

class _TelegramPairingScreenState extends ConsumerState<TelegramPairingScreen> {
  final _codeController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;
  List<Map<String, dynamic>> _pairingRequests = [];
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _fetchPairings();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchPairings());
  }

  Future<void> _fetchPairings() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance!;
      final pairings = await apiClient.listPairing(instance.instanceId, 'telegram');
      if (mounted) {
        setState(() => _pairingRequests = pairings);
      }
    } catch (_) {}
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
      _pollTimer?.cancel();
      if (mounted) {
        ref.read(setupProgressProvider.notifier).state = OnboardingStep.dashboard;
      }
    } catch (e) {
      setState(() {
        _error = '페어링에 실패했습니다. 다시 시도해주세요.';
        _isSubmitting = false;
      });
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
            'Telegram 페어링',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '봇에게 아무 메시지를 보내면 인증 코드가 표시됩니다.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          if (_pairingRequests.isEmpty) ...[
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '메시지를 기다리고 있습니다...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ] else ...[
            ..._pairingRequests.map((req) {
              final code = req['code'] as String? ?? '';
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.telegram, color: AppColors.accent, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('인증 코드', style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 4),
                            Text(
                              code,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontFamily: 'monospace',
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: _isSubmitting ? null : () => _approve(code),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(80, 40),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('승인'),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: AppColors.error, fontSize: 13)),
          ],
          const SizedBox(height: 32),
          Divider(),
          const SizedBox(height: 16),
          Text(
            '또는 직접 코드를 입력하세요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(hintText: '인증 코드'),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _isSubmitting ? null : () {
                  final code = _codeController.text.trim();
                  if (code.isNotEmpty) _approve(code);
                },
                style: FilledButton.styleFrom(minimumSize: const Size(80, 52)),
                child: const Text('승인'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
