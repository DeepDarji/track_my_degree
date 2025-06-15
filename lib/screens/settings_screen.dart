import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/subject_provider.dart';
import '../providers/assignment_provider.dart';
import '../services/data_export_service.dart';

final notificationsEnabledProvider = StateProvider<bool>((ref) => true);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final subjects = ref.watch(subjectProvider);
    final assignments = ref.watch(assignmentProvider);
    final dataExportService = DataExportService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preferences', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text(
                  'Receive reminders for assignment due dates',
                ),
                value: notificationsEnabled,
                activeColor: kAccentGreen,
                onChanged: (value) {
                  ref.read(notificationsEnabledProvider.notifier).state = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Data Export', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Export Subjects'),
                subtitle: const Text('Save subjects data as CSV'),
                trailing: const Icon(Icons.download, color: kPrimaryBlue),
                onTap: () async {
                  final filePath = await dataExportService.exportSubjects(
                    subjects,
                  );
                  if (filePath != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Subjects exported to $filePath'),
                        backgroundColor: kAccentGreen,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Failed to export subjects. Check permissions.',
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Export Assignments'),
                subtitle: const Text('Save assignments data as CSV'),
                trailing: const Icon(Icons.download, color: kPrimaryBlue),
                onTap: () async {
                  final filePath = await dataExportService.exportAssignments(
                    assignments,
                  );
                  if (filePath != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Assignments exported to $filePath'),
                        backgroundColor: kAccentGreen,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Failed to export assignments. Check permissions.',
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
