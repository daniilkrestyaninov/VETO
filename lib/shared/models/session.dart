class Session {
  final String id;
  final String groupId;
  final String status;
  final String? finalDecisionId;
  final String?
      selectedOptionId; // Выбранный вариант (устанавливается при spinning)
  final DateTime createdAt;
  final DateTime? resolvedAt;

  Session({
    required this.id,
    required this.groupId,
    required this.status,
    this.finalDecisionId,
    this.selectedOptionId,
    required this.createdAt,
    this.resolvedAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      status: json['status'] as String,
      finalDecisionId: json['final_decision_id'] as String?,
      selectedOptionId: json['selected_option_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'status': status,
      'final_decision_id': finalDecisionId,
      'selected_option_id': selectedOptionId,
      'created_at': createdAt.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }

  bool get isWaiting => status == 'waiting';
  bool get isSpinning => status == 'spinning';
  bool get isResolved => status == 'resolved';
  bool get isVetoed => status == 'vetoed';
}
