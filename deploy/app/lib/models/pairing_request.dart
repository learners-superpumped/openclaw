class PairingRequest {
  final String code;
  final String channel;

  const PairingRequest({
    required this.code,
    required this.channel,
  });

  factory PairingRequest.fromJson(Map<String, dynamic> json) {
    return PairingRequest(
      code: json['code'] as String,
      channel: json['channel'] as String,
    );
  }
}
