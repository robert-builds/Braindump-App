import 'package:flutter/material.dart';

import '../models/weekly_review.dart';

class WeeklyReviewScreen extends StatelessWidget {
  const WeeklyReviewScreen({required this.review, super.key});

  final WeeklyReview review;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Review')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(review.weekId, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _Section(title: 'Main Themes', items: review.mainThemes),
          _Section(title: 'Recurring Patterns', items: review.recurringPatterns),
          _Section(title: 'Open Loops', items: review.openLoops),
          _Section(title: 'Suggested Next Steps', items: review.suggestedNextSteps),
          _Section(title: 'Suggested Drops', items: review.suggestedDrops),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.isEmpty ? const ['Nothing clear this week.'] : items;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final item in visibleItems)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• $item'),
              ),
          ],
        ),
      ),
    );
  }
}
