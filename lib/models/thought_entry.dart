enum ThoughtSource { text, voice }

enum ThoughtStatus { active, done, dropped, archived }

class ThoughtEntry {
  const ThoughtEntry({
    required this.id,
    required this.createdAt,
    required this.source,
    required this.status,
    required this.body,
    this.tags = const <String>[],
  });

  final String id;
  final DateTime createdAt;
  final ThoughtSource source;
  final ThoughtStatus status;
  final List<String> tags;
  final String body;

  ThoughtEntry copyWith({
    ThoughtStatus? status,
    List<String>? tags,
    String? body,
  }) {
    return ThoughtEntry(
      id: id,
      createdAt: createdAt,
      source: source,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      body: body ?? this.body,
    );
  }

  String get fileName {
    final stamp = createdAt
        .toIso8601String()
        .replaceAll(RegExp(r'[^0-9T]'), '')
        .substring(0, 15);
    return '$stamp-$id.md';
  }

  String toMarkdown() {
    final buffer = StringBuffer()
      ..writeln('---')
      ..writeln('id: $id')
      ..writeln('created_at: ${createdAt.toIso8601String()}')
      ..writeln('source: ${source.name}')
      ..writeln('status: ${status.name}')
      ..writeln('tags:');

    for (final tag in tags) {
      buffer.writeln('  - $tag');
    }

    buffer
      ..writeln('---')
      ..writeln()
      ..write(body.trim());

    return buffer.toString();
  }

  static ThoughtEntry fromMarkdown(String markdown) {
    final parts = markdown.split('---');
    if (parts.length < 3) {
      throw const FormatException('Missing Markdown front matter.');
    }

    final metadata = parts[1].trim().split('\n');
    final values = <String, String>{};
    final tags = <String>[];
    var inTags = false;

    for (final rawLine in metadata) {
      final line = rawLine.trimRight();
      if (line == 'tags:') {
        inTags = true;
        continue;
      }
      if (inTags && line.trimLeft().startsWith('- ')) {
        tags.add(line.trimLeft().substring(2).trim());
        continue;
      }
      inTags = false;
      final separator = line.indexOf(':');
      if (separator > 0) {
        values[line.substring(0, separator).trim()] =
            line.substring(separator + 1).trim();
      }
    }

    return ThoughtEntry(
      id: values['id'] ?? '',
      createdAt: DateTime.parse(values['created_at'] ?? ''),
      source: ThoughtSource.values.byName(values['source'] ?? 'text'),
      status: ThoughtStatus.values.byName(values['status'] ?? 'active'),
      tags: tags,
      body: parts.sublist(2).join('---').trim(),
    );
  }
}
