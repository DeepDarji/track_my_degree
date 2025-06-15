import 'package:flutter/material.dart';
import '../core/constants.dart';

class AIScreen extends StatelessWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Study Buddy')),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Ask your AI Study Buddy for tips!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'E.g., How to revise CN in 2 days?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kCardBorderRadius),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: kPrimaryBlue),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
