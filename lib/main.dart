import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_my_degree/core/theme.dart';
import 'package:track_my_degree/screens/dashboard_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track my Degree',
      theme: appTheme,
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
