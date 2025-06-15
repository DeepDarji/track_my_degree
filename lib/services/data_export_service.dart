import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../models/subject.dart';
import '../models/assignment.dart';
import '../core/utils.dart';

class DataExportService {
  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      return false;
    }
    return true;
  }

  Future<String?> exportSubjects(List<Subject> subjects) async {
    if (!await requestStoragePermission()) {
      return null;
    }

    final List<List<dynamic>> rows = [
      ['ID', 'Name', 'Credits', 'IsBacklog', 'Attendance', 'Marks'],
      ...subjects.map(
        (subject) => [
          subject.id,
          subject.name,
          subject.credits ?? 0,
          subject.isBacklog ? 1 : 0,
          subject.attendance,
          subject.marks ?? '',
        ],
      ),
    ];

    final csv = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .substring(0, 10)
        .replaceAll('-', '');
    final filePath = '${directory.path}/subjects_$timestamp.csv';

    final file = File(filePath);
    await file.writeAsString(csv);
    return filePath;
  }

  Future<String?> exportAssignments(List<Assignment> assignments) async {
    if (!await requestStoragePermission()) {
      return null;
    }

    final List<List<dynamic>> rows = [
      ['ID', 'SubjectID', 'Title', 'DueDate', 'Progress', 'IsCompleted'],
      ...assignments.map(
        (assignment) => [
          assignment.id,
          assignment.subjectId,
          assignment.title,
          formatDate(assignment.dueDate),
          assignment.progress,
          assignment.isCompleted ? 1 : 0,
        ],
      ),
    ];

    final csv = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .substring(0, 10)
        .replaceAll('-', '');
    final filePath = '${directory.path}/assignments_$timestamp.csv';

    final file = File(filePath);
    await file.writeAsString(csv);
    return filePath;
  }
}
