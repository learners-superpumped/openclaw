class Instance {
  final String id;
  final String instanceId;
  final String? displayName;
  final ManagerStatus? manager;
  final DateTime createdAt;

  const Instance({
    required this.id,
    required this.instanceId,
    this.displayName,
    this.manager,
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
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  bool get isReady => manager?.ready ?? false;
}

class ManagerStatus {
  final String phase;
  final bool ready;

  const ManagerStatus({
    required this.phase,
    required this.ready,
  });

  factory ManagerStatus.fromJson(Map<String, dynamic> json) {
    return ManagerStatus(
      phase: json['phase'] as String? ?? 'unknown',
      ready: json['ready'] as bool? ?? false,
    );
  }
}
