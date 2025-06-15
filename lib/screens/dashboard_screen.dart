import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subject_provider.dart';
import '../providers/assignment_provider.dart';
import '../widgets/subject_card.dart';
import '../widgets/progress_bar.dart';
import 'subjects_screen.dart';
import 'assignments_screen.dart';
import 'timetable_screen.dart';
import 'ai_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectProvider);
    final assignments = ref.watch(assignmentProvider);

    final backlogCount = subjects.where((s) => s.isBacklog).length;
    final pendingAssignments = assignments.where((a) => !a.isCompleted).length;
    final completionProgress =
        assignments.isEmpty
            ? 0.0
            : (assignments.where((a) => a.isCompleted).length /
                    assignments.length) *
                100;

    return Scaffold(
      appBar: AppBar(title: const Text('Track my Degree')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Subjects',
                      subjects.length.toString(),
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'Backlogs',
                      backlogCount.toString(),
                      Colors.redAccent,
                    ),
                    _buildStatCard(
                      'Pending',
                      pendingAssignments.toString(),
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ProgressBar(
              value: completionProgress,
              label: 'Assignment Completion',
            ),
            const SizedBox(height: 16),
            Text(
              'Recent Subjects',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ...subjects.take(3).map((subject) => SubjectCard(subject: subject)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      [
                        const DashboardScreen(),
                        const SubjectsScreen(),
                        const AssignmentsScreen(),
                        const TimetableScreen(),
                        const SettingsScreen(),
                        const AIScreen(),
                      ][index],
            ),
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Subjects'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'AI Buddy'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
