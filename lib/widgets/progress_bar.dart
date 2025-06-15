import 'package:flutter/material.dart';
import '../core/constants.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final String label;

  const ProgressBar({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: Colors.grey[200],
          color: kAccentGreen,
          minHeight: 8,
          borderRadius: BorderRadius.circular(kCardBorderRadius),
        ),
      ],
    );
  }
}
