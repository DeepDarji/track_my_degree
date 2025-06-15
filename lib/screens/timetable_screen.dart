import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/constants.dart';
import '../core/utils.dart';
import '../models/subject.dart';
import '../models/timetable_entry.dart';
import '../providers/subject_provider.dart';
import '../providers/timetable_provider.dart';

class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetableEntries = ref.watch(timetableProvider);
    final subjects = ref.watch(subjectProvider);

    // Group entries by day
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final Map<String, List<TimetableEntry>> entriesByDay = {
      for (var day in days)
        day: timetableEntries.where((e) => e.day == day).toList(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(kDefaultPadding),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final entries = entriesByDay[day]!;
          return Animate(
            effects: const [
              FadeEffect(),
              SlideEffect(begin: Offset(0, 0.1), end: Offset.zero),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    day,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: kPrimaryBlue),
                  ),
                ),
                if (entries.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'No classes scheduled',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                else
                  ...entries.map((entry) {
                    final subject = subjects.firstWhere(
                      (s) => s.id == entry.subjectId,
                      orElse:
                          () => Subject(id: '', name: 'Unknown', credits: 0),
                    );
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kAccentGreen,
                          child: Text(
                            subject.name[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text('${subject.name} - ${entry.location}'),
                        subtitle: Text(
                          '${formatTimeOfDay(entry.startTime)} - ${formatTimeOfDay(entry.endTime)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            ref
                                .read(timetableProvider.notifier)
                                .deleteEntry(entry.id);
                          },
                        ),
                      ),
                    );
                  }),
                const Divider(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryBlue,
        onPressed: () => _showAddEntryDialog(context, ref, subjects),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEntryDialog(
    BuildContext context,
    WidgetRef ref,
    List<Subject> subjects,
  ) {
    final TextEditingController locationController = TextEditingController();
    String? selectedSubjectId;
    String? selectedDay;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Timetable Entry'),
            content: StatefulBuilder(
              builder:
                  (context, setState) => SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          hint: const Text('Select Subject'),
                          value: selectedSubjectId,
                          isExpanded: true,
                          items:
                              subjects
                                  .map(
                                    (subject) => DropdownMenuItem(
                                      value: subject.id,
                                      child: Text(subject.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) =>
                                  setState(() => selectedSubjectId = value),
                        ),
                        DropdownButton<String>(
                          hint: const Text('Select Day'),
                          value: selectedDay,
                          isExpanded: true,
                          items:
                              [
                                    'Monday',
                                    'Tuesday',
                                    'Wednesday',
                                    'Thursday',
                                    'Friday',
                                    'Saturday',
                                    'Sunday',
                                  ]
                                  .map(
                                    (day) => DropdownMenuItem(
                                      value: day,
                                      child: Text(day),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) => setState(() => selectedDay = value),
                        ),
                        TextButton(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() => startTime = time);
                            }
                          },
                          child: Text(
                            startTime != null
                                ? 'Start: ${formatTimeOfDay(startTime!)}'
                                : 'Select Start Time',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() => endTime = time);
                            }
                          },
                          child: Text(
                            endTime != null
                                ? 'End: ${formatTimeOfDay(endTime!)}'
                                : 'Select End Time',
                          ),
                        ),
                        TextField(
                          controller: locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location (e.g., Room 101)',
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedSubjectId != null &&
                      selectedDay != null &&
                      startTime != null &&
                      endTime != null) {
                    final entry = TimetableEntry(
                      id: const Uuid().v4(),
                      subjectId: selectedSubjectId!,
                      day: selectedDay!,
                      startTime: startTime!,
                      endTime: endTime!,
                      location:
                          locationController.text.isEmpty
                              ? 'TBD'
                              : locationController.text,
                    );
                    ref.read(timetableProvider.notifier).addEntry(entry);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}
