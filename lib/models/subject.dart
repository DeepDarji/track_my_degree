class Subject {
  final String id;
  final String name;
  final int credits;
  final bool isBacklog;
  final double attendance;
  final double? marks;

  Subject({
    required this.id,
    required this.name,
    required this.credits,
    this.isBacklog = false,
    this.attendance = 0.0,
    this.marks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'credits': credits,
      'isBacklog': isBacklog ? 1 : 0,
      'attendance': attendance,
      'marks': marks,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
      credits: map['credits'],
      isBacklog: map['isBacklog'] == 1,
      attendance: map['attendance'],
      marks: map['marks'],
    );
  }
}
