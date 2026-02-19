class ChatSession {
  final String key;
  final String? displayName;
  final String? derivedTitle;
  final DateTime? updatedAt;

  const ChatSession({
    required this.key,
    this.displayName,
    this.derivedTitle,
    this.updatedAt,
  });

  /// Returns the best available name for display.
  String get title =>
      displayName ?? derivedTitle ?? _formatKeyForDisplay(key);

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    final updatedAtRaw = json['updatedAt'];
    DateTime? updatedAt;
    if (updatedAtRaw is int) {
      updatedAt = DateTime.fromMillisecondsSinceEpoch(updatedAtRaw);
    }

    return ChatSession(
      key: json['key'] as String,
      displayName: json['displayName'] as String?,
      derivedTitle: json['derivedTitle'] as String?,
      updatedAt: updatedAt,
    );
  }

  /// Format a session key like "agent:main:main" into a readable name.
  static String _formatKeyForDisplay(String key) {
    final parts = key.split(':');
    if (parts.length >= 3) {
      return parts.last;
    }
    return key;
  }
}
