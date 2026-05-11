import 'dart:io';

import 'package:braindump_app/models/thought_entry.dart';
import 'package:braindump_app/services/app_paths.dart';
import 'package:braindump_app/services/thought_repository.dart';
import 'package:braindump_app/services/weekly_review_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generates and persists a weekly review Markdown file', () async {
    final tempDir = await Directory.systemTemp.createTemp('braindump_review_test_');
    addTearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    final paths = AppPaths(tempDir);
    final repository = ThoughtRepository(paths);
    await repository.createThought(
      body: 'Should I clarify responsibilities?',
      source: ThoughtSource.text,
      tags: const <String>['work'],
    );
    await repository.createThought(
      body: 'Running helped me think clearly.',
      source: ThoughtSource.text,
      tags: const <String>['work'],
    );

    final service = WeeklyReviewService(paths: paths, repository: repository);
    final review = await service.generate(now: DateTime.utc(2026, 5, 7, 17));
    final reviewFile = File('${tempDir.path}/${review.fileName}');

    expect(review.weekId, '2026-week-19');
    expect(review.mainThemes.first, 'Repeated topic: work');
    expect(await reviewFile.exists(), isTrue);
    expect(await reviewFile.readAsString(), contains('## Open Loops'));
  });
}
