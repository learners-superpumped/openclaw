import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/channel.dart';
import '../models/instance.dart';
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
  DateTime? _lastLoadAt;

  ChannelNotifier(this._ref) : super(const ChannelState());

  Future<void> loadAll({bool force = false}) async {
    // Debounce: skip if loaded within 25 seconds (unless forced)
    if (!force && _lastLoadAt != null) {
      final elapsed = DateTime.now().difference(_lastLoadAt!);
      if (elapsed < const Duration(seconds: 25)) return;
    }

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
    final instanceId = instance.instanceId;

    // Single unified status call
    Map<String, dynamic> allStatus;
    try {
      allStatus = await apiClient.getAllChannelsStatus(instanceId, probe: true);
    } catch (_) {
      state = state.copyWith(isLoading: false);
      return;
    }

    _lastLoadAt = DateTime.now();

    final connected = allStatus['connected'] as Map<String, dynamic>? ?? {};
    final channels = allStatus['channels'] as Map<String, dynamic>? ?? {};

    final waConnected = connected['whatsapp'] == true;
    final tgConnected = connected['telegram'] == true;
    final dcConnected = connected['discord'] == true;

    // Extract subtitles from channel data
    String? tgBotUsername;
    if (tgConnected) {
      final tg = channels['telegram'] as Map<String, dynamic>?;
      final probe = tg?['probe'] as Map<String, dynamic>?;
      final bot = probe?['bot'] as Map<String, dynamic>?;
      tgBotUsername = bot?['username'] as String?;
    }

    String? waPhone;
    if (waConnected) {
      final wa = channels['whatsapp'] as Map<String, dynamic>?;
      waPhone = wa?['phone'] as String?;
    }

    String? dcBotName;
    if (dcConnected) {
      final dc = channels['discord'] as Map<String, dynamic>?;
      dcBotName = dc?['name'] as String?;
    }

    // Fetch pairing counts in parallel for connected channels
    final pairingFutures = <ChannelType, Future<int>>{};
    if (waConnected) {
      pairingFutures[ChannelType.whatsapp] = _fetchPairingCount(apiClient, instanceId, 'whatsapp');
    }
    if (tgConnected) {
      pairingFutures[ChannelType.telegram] = _fetchPairingCount(apiClient, instanceId, 'telegram');
    }
    if (dcConnected) {
      pairingFutures[ChannelType.discord] = _fetchPairingCount(apiClient, instanceId, 'discord');
    }

    final pairingCounts = <ChannelType, int>{};
    if (pairingFutures.isNotEmpty) {
      final entries = pairingFutures.entries.toList();
      final counts = await Future.wait(entries.map((e) => e.value));
      for (var i = 0; i < entries.length; i++) {
        pairingCounts[entries[i].key] = counts[i];
      }
    }

    final results = <ChannelType, ChannelInfo>{
      ChannelType.telegram: ChannelInfo(
        type: ChannelType.telegram,
        displayName: 'Telegram',
        isConnected: tgConnected,
        subtitle: tgBotUsername != null ? '@$tgBotUsername' : null,
        pendingPairings: pairingCounts[ChannelType.telegram] ?? 0,
      ),
      ChannelType.whatsapp: ChannelInfo(
        type: ChannelType.whatsapp,
        displayName: 'WhatsApp',
        isConnected: waConnected,
        subtitle: waPhone,
        pendingPairings: pairingCounts[ChannelType.whatsapp] ?? 0,
      ),
      ChannelType.discord: ChannelInfo(
        type: ChannelType.discord,
        displayName: 'Discord',
        isConnected: dcConnected,
        subtitle: dcBotName,
        pendingPairings: pairingCounts[ChannelType.discord] ?? 0,
      ),
    };

    state = ChannelState(channels: results, isLoading: false);
  }

  void updateFromEmbedded(EmbeddedChannels embedded) {
    _lastLoadAt = DateTime.now();

    final channels = embedded.channelDetails;

    String? tgBotUsername;
    if (embedded.connected['telegram'] == true) {
      final tg = channels['telegram'] as Map<String, dynamic>?;
      final probe = tg?['probe'] as Map<String, dynamic>?;
      final bot = probe?['bot'] as Map<String, dynamic>?;
      tgBotUsername = bot?['username'] as String?;
    }

    String? waPhone;
    if (embedded.connected['whatsapp'] == true) {
      final wa = channels['whatsapp'] as Map<String, dynamic>?;
      waPhone = wa?['phone'] as String?;
    }

    String? dcBotName;
    if (embedded.connected['discord'] == true) {
      final dc = channels['discord'] as Map<String, dynamic>?;
      dcBotName = dc?['name'] as String?;
    }

    final results = <ChannelType, ChannelInfo>{
      ChannelType.telegram: ChannelInfo(
        type: ChannelType.telegram,
        displayName: 'Telegram',
        isConnected: embedded.connected['telegram'] ?? false,
        subtitle: tgBotUsername != null ? '@$tgBotUsername' : null,
        pendingPairings: embedded.pairingCounts['telegram'] ?? 0,
      ),
      ChannelType.whatsapp: ChannelInfo(
        type: ChannelType.whatsapp,
        displayName: 'WhatsApp',
        isConnected: embedded.connected['whatsapp'] ?? false,
        subtitle: waPhone,
        pendingPairings: embedded.pairingCounts['whatsapp'] ?? 0,
      ),
      ChannelType.discord: ChannelInfo(
        type: ChannelType.discord,
        displayName: 'Discord',
        isConnected: embedded.connected['discord'] ?? false,
        subtitle: dcBotName,
        pendingPairings: embedded.pairingCounts['discord'] ?? 0,
      ),
    };

    state = ChannelState(channels: results, isLoading: false);
  }

  Future<int> _fetchPairingCount(dynamic apiClient, String instanceId, String channel) async {
    try {
      final codes = await apiClient.listPairing(instanceId, channel);
      return codes.length;
    } catch (_) {
      return 0;
    }
  }
}

final channelProvider = StateNotifierProvider<ChannelNotifier, ChannelState>((ref) {
  return ChannelNotifier(ref);
});
