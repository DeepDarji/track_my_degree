import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants.dart';
import '../models/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [FadeEffect(), ScaleEffect()],
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: 8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    subject.isBacklog ? Colors.redAccent : kPrimaryBlue,
                child: Text(
                  subject.name[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: kDefaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Credits: ${subject.credits} | Attendance: ${subject.attendance.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (subject.isBacklog)
                      const Text(
                        'Backlog',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
