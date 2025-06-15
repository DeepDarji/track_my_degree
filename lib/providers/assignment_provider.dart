import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_my_degree/providers/subject_provider.dart';
import '../models/assignment.dart';
import '../services/db_service.dart';

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
}
