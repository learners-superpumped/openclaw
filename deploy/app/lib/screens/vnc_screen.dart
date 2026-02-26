import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_provider.dart';
import '../providers/instance_provider.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';
import 'vnc_view.dart';

enum _VncStatus { loading, connecting, connected, disconnected, error }

class VncScreen extends ConsumerStatefulWidget {
  const VncScreen({super.key});

  @override
  ConsumerState<VncScreen> createState() => _VncScreenState();
}

class _VncScreenState extends ConsumerState<VncScreen> {
  _VncStatus _status = _VncStatus.loading;
  String? _errorMessage;
  String? _wsUrl;
  String? _jwtToken;
  int _reloadKey = 0;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    _loadConfig();
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    super.dispose();
  }

  Future<void> _loadConfig() async {
    ref.read(analyticsProvider).logRemoteViewOpened();
    final instance = ref.read(instanceProvider).instance;
    if (instance == null) {
      setState(() {
        _status = _VncStatus.error;
        _errorMessage = 'No instance available';
      });
      return;
    }

    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: 'access_token');
    if (token == null) {
      setState(() {
        _status = _VncStatus.error;
        _errorMessage = 'Not authenticated';
      });
      return;
    }

    setState(() {
      _wsUrl =
          'wss://api.openclaw.zazz.buzz/instances/${instance.instanceId}/vnc';
      _jwtToken = token;
      _status = _VncStatus.connecting;
    });
  }

  void _onVncStatus(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    setState(() {
      switch (type) {
        case 'connected':
          _status = _VncStatus.connected;
          _errorMessage = null;
        case 'disconnected':
          _status = _VncStatus.disconnected;
        case 'error':
          _status = _VncStatus.error;
          _errorMessage = data['message'] as String?;
        default:
          break;
      }
    });
  }

  void _reload() {
    setState(() {
      _status = _VncStatus.connecting;
      _errorMessage = null;
      _reloadKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.remoteView),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: switch (_status) {
                    _VncStatus.connected => AppColors.accentGreen,
                    _VncStatus.loading ||
                    _VncStatus.connecting => AppColors.warning,
                    _VncStatus.disconnected => AppColors.textTertiary,
                    _VncStatus.error => AppColors.error,
                  },
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
            tooltip: l10n.reconnect,
          ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_status == _VncStatus.error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 12),
            Text(
              l10n.vncError,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l10n.reconnect),
            ),
          ],
        ),
      );
    }

    if (_wsUrl == null || _jwtToken == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.vncConnecting,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        VncView(
          key: ValueKey(_reloadKey),
          wsUrl: _wsUrl!,
          jwtToken: _jwtToken!,
          onStatus: _onVncStatus,
        ),
        if (_status == _VncStatus.connecting)
          Container(
            color: AppColors.background,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.vncConnecting,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
