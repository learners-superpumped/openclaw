import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../providers/api_provider.dart';
import '../providers/channel_provider.dart';
import '../providers/instance_provider.dart';
import '../theme/app_theme.dart';

class WhatsAppDetailScreen extends ConsumerStatefulWidget {
  const WhatsAppDetailScreen({super.key});

  @override
  ConsumerState<WhatsAppDetailScreen> createState() => _WhatsAppDetailScreenState();
}

class _WhatsAppDetailScreenState extends ConsumerState<WhatsAppDetailScreen> {
  bool _isConnected = false;
  String? _phone;
  bool _isLoading = true;
  bool _isGeneratingQr = false;
  String? _qrData;
  bool _isWaitingForScan = false;
  bool _isDisconnecting = false;
  List<Map<String, dynamic>> _pendingCodes = [];
  String? _approvingCode;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
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

      final status = await apiClient.getWhatsappStatus(instance.instanceId);
      final connected = status['connected'] == true;
      final phone = status['phone'] as String?;

      if (mounted) {
        setState(() {
          _isConnected = connected;
          _phone = phone;
          _isLoading = false;
          _qrData = null;
          _isWaitingForScan = false;
        });
        if (connected) {
          _startPairingPolling();
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isConnected = false;
        });
      }
    }
  }

  void _startPairingPolling() {
    _pollTimer?.cancel();
    _pollPendingCodes();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _pollPendingCodes());
  }

  Future<void> _pollPendingCodes() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance;
      if (instance == null) return;
      final codes = await apiClient.listPairing(instance.instanceId, 'whatsapp');
      if (mounted) setState(() => _pendingCodes = codes);
    } catch (_) {}
  }

  Future<void> _generateQr() async {
    setState(() => _isGeneratingQr = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance!;
      final result = await apiClient.requestWhatsappQr(instance.instanceId);
      final qrDataUrl = result['qrDataUrl'] as String?;
      if (mounted) {
        setState(() {
          _qrData = qrDataUrl;
          _isGeneratingQr = false;
        });
        if (qrDataUrl != null) {
          _waitForConnection();
        }
      }
    } catch (_) {
      if (mounted) setState(() => _isGeneratingQr = false);
    }
  }

  Future<void> _waitForConnection() async {
    setState(() => _isWaitingForScan = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance!;
      final result = await apiClient.waitForWhatsappQr(instance.instanceId);
      final connected = result['connected'] == true;
      if (mounted && connected) {
        ref.read(channelProvider.notifier).loadAll();
        _loadStatus();
      } else if (mounted) {
        setState(() => _isWaitingForScan = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isWaitingForScan = false);
    }
  }

  Future<void> _approvePairing(String code) async {
    setState(() => _approvingCode = code);
    try {
      final apiClient = ref.read(apiClientProvider);
      final instance = ref.read(instanceProvider).instance!;
      await apiClient.approvePairing(instance.instanceId, 'whatsapp', code);
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
            child: Text(l10n.cancel, style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.disconnectChannel,
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isDisconnecting = true);
    // TODO: Add WhatsApp logout API when available
    ref.read(channelProvider.notifier).loadAll();
    if (mounted) {
      setState(() {
        _isConnected = false;
        _phone = null;
        _isDisconnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.whatsapp)),
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
                              color: const Color(0xFF25D366).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 22),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.whatsapp, style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: _isConnected ? AppColors.accentGreen : AppColors.textTertiary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      _isConnected ? l10n.channelConnected : l10n.channelDisconnected,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: _isConnected ? AppColors.accentGreen : AppColors.textTertiary,
                                      ),
                                    ),
                                    if (_phone != null) ...[
                                      const SizedBox(width: 6),
                                      Text(
                                        _phone!,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
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
                            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 4),
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
                                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
                                    ),
                                  )
                                else
                                  IconButton(
                                    onPressed: () => _approvePairing(code),
                                    icon: const Icon(Icons.check_rounded, size: 18),
                                    style: IconButton.styleFrom(
                                      foregroundColor: AppColors.accent,
                                      backgroundColor: AppColors.accent.withValues(alpha: 0.1),
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
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.error),
                            )
                          : Text(l10n.disconnectChannel),
                    ),
                  ] else ...[
                    // QR Code display
                    if (_qrData != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                l10n.scanQrCode,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 240,
                                height: 240,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: _buildQrImage(),
                              ),
                              const SizedBox(height: 16),
                              if (_isWaitingForScan)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.waitingForScan,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _isGeneratingQr ? null : _generateQr,
                        child: Text(l10n.generateQrCode),
                      ),
                    ] else ...[
                      // Generate QR button
                      FilledButton.icon(
                        onPressed: _isGeneratingQr ? null : _generateQr,
                        icon: const Icon(Icons.qr_code_2_rounded),
                        label: _isGeneratingQr
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                              )
                            : Text(l10n.connectWhatsApp),
                      ),
                    ],
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildQrImage() {
    if (_qrData == null) return const SizedBox.shrink();
    // Handle data URL (data:image/png;base64,...) or raw base64
    if (_qrData!.startsWith('data:')) {
      // data URL format
      final commaIndex = _qrData!.indexOf(',');
      if (commaIndex != -1) {
        try {
          final base64Part = _qrData!.substring(commaIndex + 1);
          final bytes = base64Decode(base64Part);
          return Image.memory(bytes, fit: BoxFit.contain);
        } catch (_) {}
      }
      // Fallback: use as network image (some data URLs work directly)
      return Image.network(_qrData!, fit: BoxFit.contain);
    }
    // Try raw base64
    try {
      final bytes = base64Decode(_qrData!);
      return Image.memory(bytes, fit: BoxFit.contain);
    } catch (_) {
      // Fallback: treat as URL
      return Image.network(_qrData!, fit: BoxFit.contain);
    }
  }
}
