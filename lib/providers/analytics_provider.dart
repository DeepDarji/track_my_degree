import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assignment.dart';
import '../models/subject.dart';
import '../providers/assignment_provider.dart';
import '../providers/subject_provider.dart';

final analyticsProvider = Provider<Analytics>((ref) {
  return Analytics(ref);
});

class Analytics {
  final Ref ref;

  Analytics(this.ref);

  Map<String, double> getAssignmentStats() {
    final assignments = ref.read(assignmentProvider);
    final completed = assignments.where((a) => a.isCompleted).length.toDouble();
    final pending = assignments.where((a) => !a.isCompleted).length.toDouble();
    return {'Completed': completed, 'Pending': pending};
  }

  Map<String, double> getSubjectStats() {
    final subjects = ref.read(subjectProvider);
    final total = subjects.length.toDouble();
    final backlogs = subjects.where((s) => s.isBacklog).length.toDouble();
    final averageAttendance =
        subjects.isEmpty
            ? 0.0
            : subjects.fold(0.0, (sum, s) => sum + s.attendance) /
                subjects.length;
    return {
      'Total Subjects': total,
      'Backlogs': backlogs,
      'Average Attendance': averageAttendance,
    };
  }

  List<Map<String, dynamic>> getSubjectProgressData() {
    final subjects = ref.read(subjectProvider);
    return subjects
        .asMap()
        .entries
        .map(
          (entry) => {
            'index': entry.key,
            'name': entry.value.name,
            'attendance': entry.value.attendance,
          },
        )
        .toList();
  }
}
