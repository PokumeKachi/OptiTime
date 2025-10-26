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
  late final _nameController = TextEditingController();
  late final _groupNameController = TextEditingController();
  late final _focusNode = FocusNode();

  String? _selectedGroup = "";

  bool _promptingGroupName = false;

  @override
  void dispose() {
    _nameController.dispose();
    _groupNameController.dispose();
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

    _nameController.text = "";
    _groupNameController.text = "";
    _selectedGroup = "";
    _promptingGroupName = false;
  }

  void _createTask([String? _]) {
    final name = _nameController.text;
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
    final taskProvider = context.watch<TaskProvider>();
    final groups = taskProvider.groups;

    final _dropdownItems = [
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

    final formWidgets = [
      TextField(
        decoration: InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
        ),
        controller: _nameController,
      ),
      TextField(
        decoration: InputDecoration(
          labelText: 'Description (optional)',
          border: OutlineInputBorder(),
        ),
      ),
      _promptingGroupName
          ? TextField(
              decoration: InputDecoration(
                labelText: 'New Group Name',
                border: OutlineInputBorder(),
              ),
              controller: _groupNameController,
            )
          : DropdownButton<String?>(
              value: _selectedGroup,
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
                setState(() {
                  if (value == 'new') {
                    _promptingGroupName = true;
                  } else {
                    _selectedGroup = value;
                  }
                });
              },
            ),
    ];

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          print('received enter signal');
          if (_promptingGroupName) {
            final newGroupName = _groupNameController.text;

            if (newGroupName.isEmpty) {
              return;
            }

            _promptingGroupName = false;
            _selectedGroup = newGroupName;

            if (!(groups.any((gr) => gr.name == newGroupName))) {
              taskProvider.addGroup(TaskGroup(name: newGroupName, tasks: []));
            } else {
              setState(() {});
            }
          } else {
            _createTask();
          }
        }

        if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
          _close();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * Config.DIALOG_RATIO,
        padding: Config.MARGIN_PADDING,
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(Config.MAX_CORNER),
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
