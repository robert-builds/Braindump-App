class WeeklyReview {
  const WeeklyReview({
    required this.weekId,
    required this.createdAt,
    required this.mainThemes,
    required this.recurringPatterns,
    required this.openLoops,
    required this.suggestedNextSteps,
    required this.suggestedDrops,
  });

  final String weekId;
  final DateTime createdAt;
  final List<String> mainThemes;
  final List<String> recurringPatterns;
  final List<String> openLoops;
  final List<String> suggestedNextSteps;
  final List<String> suggestedDrops;

  String get fileName => 'reviews/$weekId.md';

  String toMarkdown() {
    return '''# Weekly Review

_generated_at: ${createdAt.toIso8601String()}_

## Main Themes
${_bullets(mainThemes)}

## Recurring Patterns
${_bullets(recurringPatterns)}

## Open Loops
${_bullets(openLoops)}

## Suggested Next Steps
${_bullets(suggestedNextSteps)}

## Suggested Drops
${_bullets(suggestedDrops)}
''';
  }

  static String _bullets(List<String> items) {
    if (items.isEmpty) {
      return '- Nothing clear this week.';
    }
    return items.map((item) => '- $item').join('\n');
  }
}
