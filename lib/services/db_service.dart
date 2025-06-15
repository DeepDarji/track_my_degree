import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/subject.dart';
import '../models/assignment.dart';
import '../models/timetable_entry.dart';

class DbService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'track_my_degree.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE subjects (
            id TEXT PRIMARY KEY,
            name TEXT,
            credits INTEGER,
            isBacklog INTEGER,
            attendance REAL,
            marks REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE assignments (
            id TEXT PRIMARY KEY,
            subjectId TEXT,
            title TEXT,
            dueDate TEXT,
            progress REAL,
            isCompleted INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE timetable (
            id TEXT PRIMARY KEY,
            subjectId TEXT,
            day TEXT,
            startTime TEXT,
            endTime TEXT,
            location TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertSubject(Subject subject) async {
    final db = await database;
    await db.insert(
      'subjects',
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Subject>> getSubjects() async {
    final db = await database;
    final maps = await db.query('subjects');
    return maps.map((map) => Subject.fromMap(map)).toList();
  }

  Future<void> insertAssignment(Assignment assignment) async {
    final db = await database;
    await db.insert(
      'assignments',
      assignment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Assignment>> getAssignments() async {
    final db = await database;
    final maps = await db.query('assignments');
    return maps.map((map) => Assignment.fromMap(map)).toList();
  }
}
