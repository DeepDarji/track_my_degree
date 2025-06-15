import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_my_degree/models/subject.dart';
import '../core/constants.dart';
import '../core/utils.dart';
import '../models/assignment.dart';
import '../providers/assignment_provider.dart';
import '../providers/subject_provider.dart';
import 'progress_bar.dart';

class AssignmentTile extends ConsumerWidget {
  final Assignment assignment;

  const AssignmentTile({super.key, required this.assignment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectProvider);
    final subject = subjects.firstWhere(
      (s) => s.id == assignment.subjectId,
      orElse: () => Subject(id: '', name: 'Unknown', credits: 0),
    );

    return Animate(
      effects: const [
        FadeEffect(),
        SlideEffect(begin: Offset(0, 0.1), end: Offset.zero),
      ],
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: 8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            children: [
              Checkbox(
                value: assignment.isCompleted,
                activeColor: kAccentGreen,
                onChanged: (value) {
                  ref
                      .read(assignmentProvider.notifier)
                      .toggleCompletion(assignment.id);
                },
              ),
              const SizedBox(width: kDefaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Subject: ${subject.name}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Due: ${formatDate(assignment.dueDate)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            assignment.dueDate.isBefore(DateTime.now()) &&
                                    !assignment.isCompleted
                                ? Colors.redAccent
                                : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ProgressBar(value: assignment.progress, label: 'Progress'),
                  ],
                ),
              ),
              if (assignment.isCompleted)
                const Icon(Icons.check_circle, color: kAccentGreen),
            ],
          ),
        ),
      ),
    );
  }
}
