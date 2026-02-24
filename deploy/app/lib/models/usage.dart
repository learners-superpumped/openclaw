class Usage {
  final int usage;
  final String? limitReset;

  const Usage({required this.usage, this.limitReset});

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      usage: (json['usage'] as num).toInt(),
      limitReset: json['limitReset'] as String?,
    );
  }

  double get fraction => (usage / 100).clamp(0.0, 1.0);

  bool get hasLimit => usage > 0 || limitReset != null;
}
