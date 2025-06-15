import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_my_degree/core/theme.dart';
import 'package:track_my_degree/providers/theme_provider.dart';
import 'package:track_my_degree/screens/dashboard_screen.dart';
import 'package:track_my_degree/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Track my Degree',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
