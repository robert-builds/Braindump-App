import 'package:flutter/material.dart';

import '../models/thought_entry.dart';
import '../services/thought_repository.dart';
import '../services/weekly_review_service.dart';
import 'thought_composer.dart';
import 'thought_feed.dart';
import 'weekly_review_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.repository,
    required this.reviewService,
    super.key,
  });

  final ThoughtRepository repository;
  final WeeklyReviewService reviewService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _entries = <ThoughtEntry>[];
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final entries = await widget.repository.loadAll();
    if (!mounted) {
      return;
    }
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  Future<void> _captureText() async {
    final text = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ThoughtComposer(),
    );
    if (text == null || text.trim().isEmpty) {
      return;
    }
    await widget.repository.createTextThought(text);
    await _reload();
  }

  Future<void> _generateReview() async {
    final review = await widget.reviewService.generate();
    if (!mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => WeeklyReviewScreen(review: review),
      ),
    );
  }

  Future<void> _updateStatus(ThoughtEntry entry, ThoughtStatus status) async {
    await widget.repository.updateStatus(entry, status);
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Braindump'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Generate weekly review',
            onPressed: _generateReview,
            icon: const Icon(Icons.auto_stories_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'A quiet place for thoughts before they become tasks.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _captureText,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Write'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showVoicePlaceholder(context),
                      icon: const Icon(Icons.mic_none_outlined),
                      label: const Text('Speak'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ThoughtFeed(
                        entries: _entries,
                        onStatusChanged: _updateStatus,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVoicePlaceholder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice capture shell is ready; whisper.cpp wiring is next.'),
      ),
    );
  }
}
