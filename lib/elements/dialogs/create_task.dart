import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/task.dart';

import 'shared/action_row.dart' as ActionRow;
import 'shared/autocomplete.dart' as Autocomplete;

class Class extends StatefulWidget {
  final int index;

  const Class({super.key, required this.index});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> with SingleTickerProviderStateMixin {
  late final _nameController = TextEditingController();
  late TextEditingController _groupController = TextEditingController();

  // bool _groupMatchExists() {
  //   final groupName = _groupController.text.toLowerCase();
  //   final groups = context.read<TaskProvider>().groups;
  //   if (groupName.isEmpty) return groups.isNotEmpty;
  //
  //   print(groupName);
  //   return groups.any((g) => g.name.toLowerCase().contains(groupName));
  // }
  //
  // void _onGroupTextChanged() {
  //   if (_groupMatchExists()) {
  //   print('yuh');
  //     _groupInputAnimationController.forward();
  //   } else {
  //   print('nuh');
  //     _groupInputAnimationController.reverse();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint('create task dialog rebuild');

    final colorScheme = Theme.of(context).colorScheme;

    final dialogIndex = context.watch<DialogIndexProvider>();
    final visible = widget.index == dialogIndex.value;
    final taskProvider = context.watch<TaskProvider>();
    final groups = taskProvider.groups;

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final portrait = height > width;

    final formWidgets = [
      TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Config.CORNER.MAX),
          ),
        ),
      ),
      Autocomplete.Class(
        controller: _groupController,
        getOptions: () => taskProvider.groups.map((g) => g.name).toList(),
      ),
    ];

    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.enter:
              _createTask();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.escape:
              _close();
              return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        width: 400,
        padding: Config.MARGIN_PADDING,
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(Config.CORNER.MAX),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // shrink to content
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

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _close() {
    FocusScope.of(context).unfocus();
    context.read<DialogIndexProvider>().value = 0;

    _nameController.text = "";
    _groupController.text = "";
  }

  void _createTask([String? _]) {
    final taskProvider = context.read<TaskProvider>();

    final name = _nameController.text;
    final groupName = _groupController.text;
    debugPrint('');
    debugPrint('Creating a new task from the dialog');
    debugPrint('Name: $name');
    debugPrint('Group: $groupName');
    debugPrint('');

    if (name.isEmpty) {
      return;
    }

    final task = Task(name: name ?? '');

    if (groupName.isEmpty) {
      context.read<TaskProvider>().addTask(task);
    } else {
      final group = taskProvider.groups.firstWhere(
        (g) => g.name == groupName,
        orElse: () {
          final group = TaskGroup(name: groupName, tasks: []);
          taskProvider.addGroup(group);
          return group;
        },
      );

      taskProvider.addTaskToGroup(task, group);
    }

    _close();
  }
}
