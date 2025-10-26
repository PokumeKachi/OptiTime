import 'package:flutter/material.dart';
// import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  late final nameController = TextEditingController();

  late String? selectedGroup = "";
  late List<DropdownMenuItem<String?>> dropdownItems;

  bool promptingGroupName = false;

  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dialogIndex = context.read<DialogIndexProvider>().value;
    if (widget.index == dialogIndex) {
      Future.microtask(() => _focusNode.requestFocus());
    }
  }

  void _close() {
    FocusScope.of(context).unfocus();
    context.read<DialogIndexProvider>().value = 0;
  }

  void _createTask([String? _]) {
    final name = nameController.text;
    debugPrint('Creating a new task from the dialog');
    debugPrint('Text: $name');
    context.read<TaskProvider>().addTask(Task(name: name ?? ''));
    _close();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dialogIndex = context.watch<DialogIndexProvider>();
    final visible = widget.index == dialogIndex.value;
    final groups = context.watch<TaskProvider>().groups;

    final formWidgets = [
      TextField(
        decoration: InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
        ),
        controller: nameController,
      ),
      TextField(
        decoration: InputDecoration(
          labelText: 'Description (optional)',
          border: OutlineInputBorder(),
        ),
      ),
      DropdownButton<String?>(
        value: selectedGroup,
        items: [
          const DropdownMenuItem(value: '', child: Text('<No Group>')),
          ...groups.map(
            (g) => DropdownMenuItem(value: g.name, child: Text(g.name)),
          ),
          DropdownMenuItem(
            value: 'new',
            child: Text(
              '<New Group>',
              style: TextStyle(
                backgroundColor: colorScheme.tertiary,
                color: colorScheme.onTertiary,
              ),
            ),
          ),
        ],
        onChanged: (value) {
          if (value == 'new') {
            promptingGroupName = true;
          } else {
            setState(() => selectedGroup = value);
          }
        },
      ),
    ];

    dropdownItems = [
      const DropdownMenuItem(value: '', child: Text('<No Group>')),
      ...groups.map(
        (g) => DropdownMenuItem(value: '.' + g.name, child: Text(g.name)),
      ),
      DropdownMenuItem(
        value: 'new',
        child: Text(
          '<New Group>',
          style: TextStyle(
            backgroundColor: colorScheme.tertiary,
            color: colorScheme.onTertiary,
          ),
        ),
      ),
    ];

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          if (promptingGroupName) {
            promptingGroupName = false;
          } else {
            _createTask();
          }
        }
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'New Task',
              style: TextStyle(
                fontSize: Config.FONT_SIZE.BIG,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Config.ITEM_PADDING.MEDIUM),

            for (final widget in formWidgets) ...[
              widget,
              const SizedBox(height: Config.ITEM_PADDING.MEDIUM),
            ],

            ActionRow.Class(
              visible: visible,
              buttons: [
                ActionRow.Button(
                  text: 'Cancel',
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: colorScheme.onBackground,
                  ),
                  callback: _close,
                ),
                ActionRow.Button(
                  text: 'Create',
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  callback: _createTask,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
