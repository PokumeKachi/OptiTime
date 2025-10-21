import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/task.dart';
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/config.dart' as Config;

import 'shared/action_row.dart' as ActionRow;

class Class extends StatefulWidget {
  const Class({super.key, required this.index});

  final int index;

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> with SingleTickerProviderStateMixin {
  late final List<TextEditingController> _editControllers;

  void _createTask([String? _]) {
    final text = _editControllers[0].text;
    print('Text: $text');
    context.read<TaskListProvider>().createTask(Task(title: text));

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final dialogIndex = context.watch<DialogIndexProvider>();
    final visible = widget.index == dialogIndex.value;
    return Container(
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
              onSubmitted: _createTask,
            ),
            const SizedBox(height: Config.ITEM_PADDING),
            ActionRow.Class(
              visible: visible,
              buttons: [
                ActionRow.Button(
                  text: 'Cancel',
                  callback: () {
                    context.read<DialogIndexProvider>().value = 0;
                    debugPrint('help');
                  },
                ),
                ActionRow.Button(text: 'Create'),
              ],
            ),
          ],
        ),
    );
  }
}
