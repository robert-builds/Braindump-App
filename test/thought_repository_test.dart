import 'dart:io';

import 'package:braindump_app/models/thought_entry.dart';
import 'package:braindump_app/services/app_paths.dart';
import 'package:braindump_app/services/thought_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late ThoughtRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('braindump_repo_test_');
    repository = ThoughtRepository(AppPaths(tempDir));
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('creates text thoughts as Markdown files', () async {
    final entry = await repository.createTextThought('A quiet thought');
    final entries = await repository.loadAll();

    expect(entry.status, ThoughtStatus.active);
    expect(entries, hasLength(1));
    expect(entries.single.body, 'A quiet thought');
    expect(File('${tempDir.path}/entries/${entry.fileName}').existsSync(), isTrue);
  });

  test('updates status without changing body', () async {
    final entry = await repository.createTextThought('Resolved thought');
    await repository.updateStatus(entry, ThoughtStatus.done);

    final entries = await repository.loadAll();

    expect(entries.single.status, ThoughtStatus.done);
    expect(entries.single.body, 'Resolved thought');
  });
}
