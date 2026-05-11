import 'package:flutter/material.dart';

import 'models/thought_entry.dart';
import 'services/app_paths.dart';
import 'services/thought_repository.dart';
import 'services/weekly_review_service.dart';
import 'ui/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final paths = await AppPaths.load();
  await paths.ensureCreated();
  final repository = ThoughtRepository(paths);
  runApp(BraindumpApp(paths: paths, repository: repository));
}

class BraindumpApp extends StatelessWidget {
  const BraindumpApp({
    required this.paths,
    required this.repository,
    super.key,
  });

  final AppPaths paths;
  final ThoughtRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Braindump',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6F7D6A),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F4EE),
        useMaterial3: true,
      ),
      home: HomeScreen(
        repository: repository,
        reviewService: WeeklyReviewService(
          paths: paths,
          repository: repository,
        ),
      ),
    );
  }
}

class ThoughtStatusChip extends StatelessWidget {
  const ThoughtStatusChip({required this.status, super.key});

  final ThoughtStatus status;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status.name),
      visualDensity: VisualDensity.compact,
    );
  }
}
