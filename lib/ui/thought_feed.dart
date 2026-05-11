import 'package:flutter/material.dart';

import '../models/thought_entry.dart';

class ThoughtFeed extends StatelessWidget {
  const ThoughtFeed({
    required this.entries,
    required this.onStatusChanged,
    super.key,
  });

  final List<ThoughtEntry> entries;
  final Future<void> Function(ThoughtEntry entry, ThoughtStatus status)
      onStatusChanged;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(
        child: Text('No thoughts yet. Capture one when it appears.'),
      );
    }

    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      entry.source == ThoughtSource.voice
                          ? Icons.mic_none_outlined
                          : Icons.notes_outlined,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.createdAt.toLocal().toString().split('.').first,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    _StatusMenu(entry: entry, onChanged: onStatusChanged),
                  ],
                ),
                const SizedBox(height: 8),
                Text(entry.body),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusMenu extends StatelessWidget {
  const _StatusMenu({required this.entry, required this.onChanged});

  final ThoughtEntry entry;
  final Future<void> Function(ThoughtEntry entry, ThoughtStatus status) onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ThoughtStatus>(
      initialValue: entry.status,
      tooltip: 'Change status',
      onSelected: (status) => onChanged(entry, status),
      itemBuilder: (context) {
        return ThoughtStatus.values
            .map(
              (status) => PopupMenuItem<ThoughtStatus>(
                value: status,
                child: Text(status.name),
              ),
            )
            .toList();
      },
      child: Chip(label: Text(entry.status.name)),
    );
  }
}
