import 'package:braindump_app/models/thought_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializes and parses Markdown front matter', () {
    final entry = ThoughtEntry(
      id: 'abc123',
      createdAt: DateTime.utc(2026, 5, 7, 8, 15, 22),
      source: ThoughtSource.voice,
      status: ThoughtStatus.active,
      tags: const <String>['work', 'frustration'],
      body: 'Heute wieder extrem mühsames Meeting.',
    );

    final parsed = ThoughtEntry.fromMarkdown(entry.toMarkdown());

    expect(parsed.id, 'abc123');
    expect(parsed.createdAt, DateTime.utc(2026, 5, 7, 8, 15, 22));
    expect(parsed.source, ThoughtSource.voice);
    expect(parsed.status, ThoughtStatus.active);
    expect(parsed.tags, const <String>['work', 'frustration']);
    expect(parsed.body, 'Heute wieder extrem mühsames Meeting.');
  });
}
