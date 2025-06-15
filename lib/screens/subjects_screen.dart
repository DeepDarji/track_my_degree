import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/subject.dart';
import '../providers/subject_provider.dart';
import '../widgets/subject_card.dart';

class SubjectsScreen extends ConsumerWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectProvider);
    final TextEditingController nameController = TextEditingController();
    final TextEditingController creditsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subjects.length,
        itemBuilder: (context, index) => SubjectCard(subject: subjects[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Add Subject'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Subject Name',
                        ),
                      ),
                      TextField(
                        controller: creditsController,
                        decoration: const InputDecoration(labelText: 'Credits'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final subject = Subject(
                          id: const Uuid().v4(),
                          name: nameController.text,
                          credits: int.tryParse(creditsController.text) ?? 0,
                        );
                        ref.read(subjectProvider.notifier).addSubject(subject);
                        Navigator.pop(context);
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
