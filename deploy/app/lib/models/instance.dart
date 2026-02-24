class Instance {
  final String id;
  final String instanceId;
  final String? displayName;
  final ManagerStatus? manager;
  final EmbeddedChannels? channels;
  final DateTime createdAt;

  const Instance({
    required this.id,
    required this.instanceId,
    this.displayName,
    this.manager,
    this.channels,
    required this.createdAt,
  });

  factory Instance.fromJson(Map<String, dynamic> json) {
    return Instance(
      id: json['id'] as String,
      instanceId: json['instanceId'] as String,
      displayName: json['displayName'] as String?,
      manager: json['manager'] != null
          ? ManagerStatus.fromJson(json['manager'] as Map<String, dynamic>)
          : null,
      channels: json['channels'] != null
          ? EmbeddedChannels.fromJson(json['channels'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  bool get isReady => manager?.ready ?? false;
}

class EmbeddedChannels {
  final Map<String, bool> connected;
  final Map<String, dynamic> channelDetails;
  final Map<String, int> pairingCounts;

  const EmbeddedChannels({
    required this.connected,
    required this.channelDetails,
    required this.pairingCounts,
  });

  factory EmbeddedChannels.fromJson(Map<String, dynamic> json) {
    final connected = <String, bool>{};
    final rawConnected = json['connected'] as Map<String, dynamic>? ?? {};
    for (final entry in rawConnected.entries) {
      connected[entry.key] = entry.value == true;
    }

    final channelDetails = json['channels'] as Map<String, dynamic>? ?? {};

    final pairingCounts = <String, int>{};
    final rawPairing = json['pairingCounts'] as Map<String, dynamic>? ?? {};
    for (final entry in rawPairing.entries) {
      pairingCounts[entry.key] = (entry.value as num?)?.toInt() ?? 0;
    }

    return EmbeddedChannels(
      connected: connected,
      channelDetails: channelDetails,
      pairingCounts: pairingCounts,
    );
  }
}

class ManagerStatus {
  final String phase;
  final bool ready;
  final IngressStatus? ingress;
  final CertificateStatus? certificate;
  final bool? gatewayReady;
  final String? gatewayUrl;
  final String? gatewayToken;

  const ManagerStatus({
    required this.phase,
    required this.ready,
    this.ingress,
    this.certificate,
    this.gatewayReady,
    this.gatewayUrl,
    this.gatewayToken,
  });

  factory ManagerStatus.fromJson(Map<String, dynamic> json) {
    return ManagerStatus(
      phase: json['phase'] as String? ?? 'unknown',
      ready: json['ready'] as bool? ?? false,
      ingress: json['ingress'] != null
          ? IngressStatus.fromJson(json['ingress'] as Map<String, dynamic>)
          : null,
      certificate: json['certificate'] != null
          ? CertificateStatus.fromJson(
              json['certificate'] as Map<String, dynamic>)
          : null,
      gatewayReady: json['gatewayReady'] as bool?,
      gatewayUrl: json['gatewayUrl'] as String?,
      gatewayToken: json['gatewayToken'] as String?,
    );
  }
}

class IngressStatus {
  final String? ip;
  final bool ready;

  const IngressStatus({this.ip, required this.ready});

  factory IngressStatus.fromJson(Map<String, dynamic> json) {
    return IngressStatus(
      ip: json['ip'] as String?,
      ready: json['ready'] as bool? ?? false,
    );
  }
}

class CertificateStatus {
  final String? status;
  final bool ready;

  const CertificateStatus({this.status, required this.ready});

  factory CertificateStatus.fromJson(Map<String, dynamic> json) {
    return CertificateStatus(
      status: json['status'] as String?,
      ready: json['ready'] as bool? ?? false,
    );
  }
}
