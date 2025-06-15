import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timetable_entry.dart';

final timetableProvider =
    StateNotifierProvider<TimetableNotifier, List<TimetableEntry>>((ref) {
      return TimetableNotifier();
    });

class TimetableNotifier extends StateNotifier<List<TimetableEntry>> {
  TimetableNotifier() : super([]);

  void addEntry(TimetableEntry entry) {
    state = [...state, entry];
  }
}
