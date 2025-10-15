import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/core/task.dart';
import 'package:todo/core/provider.dart';
import 'package:todo/core/config.dart' as Config;

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> with SingleTickerProviderStateMixin {
  late final List<TextEditingController> _editControllers;

  bool _showButtons = false;

  void _addTask([String? _]) {
    final text = _editControllers[0].text;
    print('Text: $text');
Provider.of<TaskListProvider>(
              context,
              listen: false,
            ).addTask(Task(
      title: text,
    ));

    
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _showButtons = true);
    });
    _editControllers = List.generate(3, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (final c in _editControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
    child: Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'New Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Config.ITEM_PADDING),
          TextField(
            controller: _editControllers[0],
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: _addTask,
          ),
          const SizedBox(height: Config.ITEM_PADDING),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedSlide(
                offset: _showButtons ? Offset.zero : const Offset(.3, 0),
                duration: const Duration(
                  milliseconds: Config.ANIMATION_DURATION * 2,
                ),
                curve: Curves.easeOutExpo,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: Config.ITEM_PADDING),
              AnimatedSlide(
                offset: _showButtons ? Offset.zero : const Offset(.5, 0),
                duration: const Duration(
                  milliseconds: Config.ANIMATION_DURATION * 2,
                ),
                curve: Curves.easeOutExpo,
                child: ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
