class Option {
  final String id;
  final String sessionId;
  final String title;
  final String addedBy;
  final DateTime createdAt;

  Option({
    required this.id,
    required this.sessionId,
    required this.title,
    required this.addedBy,
    required this.createdAt,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      title: json['title'] as String,
      addedBy: json['added_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'title': title,
      'added_by': addedBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
