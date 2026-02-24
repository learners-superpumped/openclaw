import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/channel.dart';
import 'api_provider.dart';
import 'instance_provider.dart';

class ChannelState {
  final Map<ChannelType, ChannelInfo> channels;
  final bool isLoading;

  const ChannelState({
    this.channels = const {},
    this.isLoading = false,
  });

  int get connectedCount => channels.values.where((c) => c.isConnected).length;
  int get totalPending => channels.values.fold(0, (sum, c) => sum + c.pendingPairings);

  ChannelState copyWith({
    Map<ChannelType, ChannelInfo>? channels,
    bool? isLoading,
  }) {
    return ChannelState(
      channels: channels ?? this.channels,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChannelNotifier extends StateNotifier<ChannelState> {
  final Ref _ref;

  ChannelNotifier(this._ref) : super(const ChannelState());

  Future<void> loadAll() async {
    // Only show loading on initial load (no existing data)
    if (state.channels.isEmpty) {
      state = state.copyWith(isLoading: true);
    }

    final instance = _ref.read(instanceProvider).instance;
    if (instance == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final apiClient = _ref.read(apiClientProvider);
    final results = <ChannelType, ChannelInfo>{};

    // Load Telegram status
    try {
      final status = await apiClient.getTelegramStatus(instance.instanceId, probe: true);
      final isConnected = status['connected'] == true;
      String? botUsername;
      if (isConnected) {
        final telegram = status['telegram'] as Map<String, dynamic>?;
        final probe = telegram?['probe'] as Map<String, dynamic>?;
        final bot = probe?['bot'] as Map<String, dynamic>?;
        botUsername = bot?['username'] as String?;
      }

      int pendingCount = 0;
      if (isConnected) {
        try {
          final codes = await apiClient.listPairing(instance.instanceId, 'telegram');
          pendingCount = codes.length;
        } catch (_) {}
      }

      results[ChannelType.telegram] = ChannelInfo(
        type: ChannelType.telegram,
        displayName: 'Telegram',
        isConnected: isConnected,
        subtitle: botUsername != null ? '@$botUsername' : null,
        pendingPairings: pendingCount,
      );
    } catch (_) {
      results[ChannelType.telegram] = const ChannelInfo(
        type: ChannelType.telegram,
        displayName: 'Telegram',
      );
    }

    // Load WhatsApp status
    try {
      final status = await apiClient.getWhatsappStatus(instance.instanceId);
      final isConnected = status['connected'] == true;
      final phone = status['phone'] as String?;

      int pendingCount = 0;
      if (isConnected) {
        try {
          final codes = await apiClient.listPairing(instance.instanceId, 'whatsapp');
          pendingCount = codes.length;
        } catch (_) {}
      }

      results[ChannelType.whatsapp] = ChannelInfo(
        type: ChannelType.whatsapp,
        displayName: 'WhatsApp',
        isConnected: isConnected,
        subtitle: phone,
        pendingPairings: pendingCount,
      );
    } catch (_) {
      results[ChannelType.whatsapp] = const ChannelInfo(
        type: ChannelType.whatsapp,
        displayName: 'WhatsApp',
      );
    }

    // Load Discord status
    try {
      final status = await apiClient.getDiscordStatus(instance.instanceId);
      final isConnected = status['connected'] == true;
      String? botUsername;
      if (isConnected) {
        final discord = status['discord'] as Map<String, dynamic>?;
        botUsername = discord?['name'] as String?;
      }
      int pendingCount = 0;
      if (isConnected) {
        try {
          final codes = await apiClient.listPairing(instance.instanceId, 'discord');
          pendingCount = codes.length;
        } catch (_) {}
      }
      results[ChannelType.discord] = ChannelInfo(
        type: ChannelType.discord,
        displayName: 'Discord',
        isConnected: isConnected,
        subtitle: botUsername,
        pendingPairings: pendingCount,
      );
    } catch (_) {
      results[ChannelType.discord] = const ChannelInfo(
        type: ChannelType.discord,
        displayName: 'Discord',
      );
    }

    state = ChannelState(channels: results, isLoading: false);
  }
}

final channelProvider = StateNotifierProvider<ChannelNotifier, ChannelState>((ref) {
  return ChannelNotifier(ref);
});
