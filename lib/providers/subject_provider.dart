import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../services/db_service.dart';

final dbServiceProvider = Provider<DbService>((ref) => DbService());

final subjectProvider = StateNotifierProvider<SubjectNotifier, List<Subject>>((
  ref,
) {
  return SubjectNotifier(ref.read(dbServiceProvider));
});

class SubjectNotifier extends StateNotifier<List<Subject>> {
  final DbService dbService;

  SubjectNotifier(this.dbService) : super([]) {
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    state = await dbService.getSubjects();
  }

  Future<void> addSubject(Subject subject) async {
    await dbService.insertSubject(subject);
    state = await dbService.getSubjects();
  }
}
