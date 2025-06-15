class Assignment {
  final String id;
  final String subjectId;
  final String title;
  final DateTime dueDate;
  final double progress;
  final bool isCompleted;

  Assignment({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.dueDate,
    this.progress = 0.0,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'progress': progress,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      subjectId: map['subjectId'],
      title: map['title'],
      dueDate: DateTime.parse(map['dueDate']),
      progress: map['progress'],
      isCompleted: map['isBacklog'] == 1,
    );
  }
}
