enum ChannelType { telegram, whatsapp }

class ChannelInfo {
  final ChannelType type;
  final String displayName;
  final bool isConnected;
  final bool isLoading;
  final String? subtitle;
  final int pendingPairings;

  const ChannelInfo({
    required this.type,
    required this.displayName,
    this.isConnected = false,
    this.isLoading = false,
    this.subtitle,
    this.pendingPairings = 0,
  });

  ChannelInfo copyWith({
    bool? isConnected,
    bool? isLoading,
    String? subtitle,
    int? pendingPairings,
  }) {
    return ChannelInfo(
      type: type,
      displayName: displayName,
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      subtitle: subtitle ?? this.subtitle,
      pendingPairings: pendingPairings ?? this.pendingPairings,
    );
  }
}
