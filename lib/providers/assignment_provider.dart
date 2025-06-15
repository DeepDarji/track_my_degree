import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_my_degree/providers/subject_provider.dart';
import '../models/assignment.dart';
import '../services/db_service.dart';
import '../services/notification_service.dart';

final assignmentProvider =
    StateNotifierProvider<AssignmentNotifier, List<Assignment>>((ref) {
      return AssignmentNotifier(ref.read(dbServiceProvider));
    });

class AssignmentNotifier extends StateNotifier<List<Assignment>> {
  final DbService dbService;

  AssignmentNotifier(this.dbService) : super([]) {
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    state = await dbService.getAssignments();
  }

  Future<void> addAssignment(Assignment assignment) async {
    await dbService.insertAssignment(assignment);
    state = await dbService.getAssignments();
  }

  Future<void> toggleCompletion(String id) async {
    final assignment = state.firstWhere((a) => a.id == id);
    final updatedAssignment = Assignment(
      id: assignment.id,
      subjectId: assignment.subjectId,
      title: assignment.title,
      dueDate: assignment.dueDate,
      progress: assignment.isCompleted ? 0.0 : 100.0,
      isCompleted: !assignment.isCompleted,
    );
    await dbService.insertAssignment(updatedAssignment);

    // Cancel notification if completed
    if (updatedAssignment.isCompleted) {
      final notificationService = NotificationService();
      await notificationService.cancelNotification(id.hashCode);
    }

    state = await dbService.getAssignments();
  }
}
