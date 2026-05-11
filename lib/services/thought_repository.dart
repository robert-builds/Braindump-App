import 'dart:io';

import 'package:uuid/uuid.dart';

import '../models/thought_entry.dart';
import 'app_paths.dart';

class ThoughtRepository {
  ThoughtRepository(this.paths, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppPaths paths;
  final Uuid _uuid;

  Future<ThoughtEntry> createTextThought(String body) {
    return createThought(body: body, source: ThoughtSource.text);
  }

  Future<ThoughtEntry> createVoiceThought(String transcript) {
    return createThought(body: transcript, source: ThoughtSource.voice);
  }

  Future<ThoughtEntry> createThought({
    required String body,
    required ThoughtSource source,
    List<String> tags = const <String>[],
  }) async {
    final cleanBody = body.trim();
    if (cleanBody.isEmpty) {
      throw ArgumentError.value(body, 'body', 'Thought body cannot be empty.');
    }

    await paths.ensureCreated();
    final entry = ThoughtEntry(
      id: _uuid.v4(),
      createdAt: DateTime.now().toUtc(),
      source: source,
      status: ThoughtStatus.active,
      tags: tags,
      body: cleanBody,
    );
    await _write(entry);
    return entry;
  }

  Future<List<ThoughtEntry>> loadAll() async {
    await paths.ensureCreated();
    final files = paths.entries
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.md'))
        .toList()
      ..sort((a, b) => b.path.compareTo(a.path));

    final entries = <ThoughtEntry>[];
    for (final file in files) {
      entries.add(ThoughtEntry.fromMarkdown(await file.readAsString()));
    }
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  Future<List<ThoughtEntry>> loadActiveSince(DateTime since) async {
    final entries = await loadAll();
    return entries
        .where(
          (entry) =>
              entry.status == ThoughtStatus.active && entry.createdAt.isAfter(since),
        )
        .toList();
  }

  Future<ThoughtEntry> updateStatus(
    ThoughtEntry entry,
    ThoughtStatus status,
  ) async {
    final updated = entry.copyWith(status: status);
    await _write(updated);
    return updated;
  }

  Future<void> _write(ThoughtEntry entry) async {
    await paths.ensureCreated();
    final file = File('${paths.entries.path}/${entry.fileName}');
    await file.writeAsString(entry.toMarkdown());
  }
}
