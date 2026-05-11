import 'package:flutter/material.dart';

class ThoughtComposer extends StatefulWidget {
  const ThoughtComposer({super.key});

  @override
  State<ThoughtComposer> createState() => _ThoughtComposerState();
}

class _ThoughtComposerState extends State<ThoughtComposer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Write a thought', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: 6,
            minLines: 3,
            decoration: const InputDecoration(
              hintText: 'No structure needed. Just unload it here.',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_controller.text),
            child: const Text('Save thought'),
          ),
        ],
      ),
    );
  }
}
