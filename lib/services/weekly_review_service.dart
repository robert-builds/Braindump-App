import 'dart:io';

import '../models/thought_entry.dart';
import '../models/weekly_review.dart';
import 'app_paths.dart';
import 'thought_repository.dart';

class WeeklyReviewService {
  WeeklyReviewService({required this.paths, required this.repository});

  final AppPaths paths;
  final ThoughtRepository repository;

  Future<WeeklyReview> generate({DateTime? now}) async {
    final timestamp = (now ?? DateTime.now().toUtc()).toUtc();
    final since = timestamp.subtract(const Duration(days: 7));
    final entries = await repository.loadActiveSince(since);
    final weekId = _weekId(timestamp);

    final review = WeeklyReview(
      weekId: weekId,
      createdAt: timestamp,
      mainThemes: _themes(entries),
      recurringPatterns: _patterns(entries),
      openLoops: _openLoops(entries),
      suggestedNextSteps: _nextSteps(entries),
      suggestedDrops: _drops(entries),
    );

    await paths.ensureCreated();
    final file = File('${paths.root.path}/${review.fileName}');
    await file.parent.create(recursive: true);
    await file.writeAsString(review.toMarkdown());
    return review;
  }

  List<String> _themes(List<ThoughtEntry> entries) {
    final tags = <String, int>{};
    for (final entry in entries) {
      for (final tag in entry.tags) {
        tags[tag] = (tags[tag] ?? 0) + 1;
      }
    }
    final sorted = tags.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (sorted.isNotEmpty) {
      return sorted.take(3).map((entry) => 'Repeated topic: ${entry.key}').toList();
    }
    return entries.take(3).map((entry) => _firstSentence(entry.body)).toList();
  }

  List<String> _patterns(List<ThoughtEntry> entries) {
    if (entries.length < 2) {
      return const <String>['Not enough entries yet to detect a reliable pattern.'];
    }
    return <String>[
      '${entries.length} active thoughts were captured in the last seven days.',
      'Voice and text entries are stored together chronologically.',
    ];
  }

  List<String> _openLoops(List<ThoughtEntry> entries) {
    return entries
        .where((entry) => entry.body.contains('?'))
        .take(3)
        .map((entry) => _firstSentence(entry.body))
        .toList();
  }

  List<String> _nextSteps(List<ThoughtEntry> entries) {
    if (entries.isEmpty) {
      return const <String>['Capture a few thoughts before the next weekly review.'];
    }
    return const <String>[
      'Read the active thoughts once and mark anything resolved as done.',
      'Choose one open loop that would create the most calm if clarified.',
    ];
  }

  List<String> _drops(List<ThoughtEntry> entries) {
    if (entries.length < 5) {
      return const <String>['No drop recommendation yet.'];
    }
    return const <String>[
      'Consider dropping repeated thoughts that no longer need action.',
    ];
  }

  String _firstSentence(String body) {
    final compact = body.replaceAll('\n', ' ').trim();
    final end = compact.indexOf(RegExp(r'[.!?]'));
    if (end > 0) {
      return compact.substring(0, end + 1);
    }
    return compact.length <= 90 ? compact : '${compact.substring(0, 87)}...';
  }

  String _weekId(DateTime date) {
    final thursday = date.add(Duration(days: 4 - date.weekday));
    final firstWeekAnchor = DateTime.utc(thursday.year, 1, 4);
    final firstThursday = firstWeekAnchor.add(
      Duration(days: 4 - firstWeekAnchor.weekday),
    );
    final week = 1 + thursday.difference(firstThursday).inDays ~/ 7;
    return '${thursday.year}-week-${week.toString().padLeft(2, '0')}';
  }
}
