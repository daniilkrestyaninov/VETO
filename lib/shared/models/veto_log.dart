class VetoLog {
  final String id;
  final String sessionId;
  final String userId;
  final String? reason;
  final DateTime usedAt;

  VetoLog({
    required this.id,
    required this.sessionId,
    required this.userId,
    this.reason,
    required this.usedAt,
  });

  factory VetoLog.fromJson(Map<String, dynamic> json) {
    return VetoLog(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      userId: json['user_id'] as String,
      reason: json['reason'] as String?,
      usedAt: DateTime.parse(json['used_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'user_id': userId,
      'reason': reason,
      'used_at': usedAt.toIso8601String(),
    };
  }
}
