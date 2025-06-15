import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/utils.dart';
import '../models/assignment.dart';
import '../providers/assignment_provider.dart';
import '../providers/subject_provider.dart';
import '../services/notification_service.dart';
import '../widgets/assignment_tile.dart';
import 'settings_screen.dart';

class AssignmentsScreen extends ConsumerWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignments = ref.watch(assignmentProvider);
    final subjects = ref.watch(subjectProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final TextEditingController titleController = TextEditingController();
    String? selectedSubjectId;
    DateTime? selectedDate;

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: assignments.length,
        itemBuilder:
            (context, index) => AssignmentTile(assignment: assignments[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Add Assignment'),
                  content: StatefulBuilder(
                    builder:
                        (context, setState) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                labelText: 'Assignment Title',
                              ),
                            ),
                            DropdownButton<String>(
                              hint: const Text('Select Subject'),
                              value: selectedSubjectId,
                              items:
                                  subjects
                                      .map(
                                        (subject) => DropdownMenuItem(
                                          value: subject.id,
                                          child: Text(subject.name),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSubjectId = value;
                                });
                              },
                            ),
                            TextButton(
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (date != null) {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                }
                              },
                              child: Text(
                                selectedDate != null
                                    ? 'Due: ${formatDate(selectedDate!)}'
                                    : 'Select Due Date',
                              ),
                            ),
                          ],
                        ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (selectedSubjectId != null && selectedDate != null) {
                          final assignment = Assignment(
                            id: const Uuid().v4(),
                            subjectId: selectedSubjectId!,
                            title: titleController.text,
                            dueDate: selectedDate!,
                          );
                          ref
                              .read(assignmentProvider.notifier)
                              .addAssignment(assignment);

                          // Schedule notification if enabled
                          if (notificationsEnabled) {
                            final notificationService = NotificationService();
                            await notificationService
                                .scheduleAssignmentNotification(
                                  id: assignment.id.hashCode,
                                  title: 'Assignment Due: ${assignment.title}',
                                  body:
                                      'Due on ${formatDate(assignment.dueDate)}',
                                  dueDate: assignment.dueDate,
                                );
                          }

                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
