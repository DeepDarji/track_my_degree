import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_my_degree/providers/subject_provider.dart';
import '../models/timetable_entry.dart';
import '../services/db_service.dart';

final timetableProvider =
    StateNotifierProvider<TimetableNotifier, List<TimetableEntry>>((ref) {
      return TimetableNotifier(ref.read(dbServiceProvider));
    });

class TimetableNotifier extends StateNotifier<List<TimetableEntry>> {
  final DbService dbService;

  TimetableNotifier(this.dbService) : super([]) {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    state = await dbService.getTimetableEntries();
  }

  Future<void> addEntry(TimetableEntry entry) async {
    await dbService.insertTimetableEntry(entry);
    state = await dbService.getTimetableEntries();
  }

  Future<void> deleteEntry(String id) async {
    await dbService.deleteTimetableEntry(id);
    state = await dbService.getTimetableEntries();
  }
}
