class GroupMember {
  final String groupId;
  final String userId;
  final String role;
  final int vetoTokens;
  final DateTime joinedAt;

  GroupMember({
    required this.groupId,
    required this.userId,
    required this.role,
    required this.vetoTokens,
    required this.joinedAt,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      groupId: json['group_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      vetoTokens: json['veto_tokens'] as int,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'user_id': userId,
      'role': role,
      'veto_tokens': vetoTokens,
      'joined_at': joinedAt.toIso8601String(),
    };
  }
}
