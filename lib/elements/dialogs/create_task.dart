import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/notify.dart' as Notify;
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/data_types.dart';

import 'shared/action_row.dart' as ActionRow;
import 'shared/autocomplete.dart' as Autocomplete;

class Class extends StatefulWidget {
  final int index;

  const Class({super.key, required this.index});

  @override
  State<Class> createState() => ClassState();
}

class ClassState extends State<Class> with SingleTickerProviderStateMixin {
  late final _nameController = TextEditingController();
  late final _groupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    debugPrint('create task dialog rebuild');

    final colorScheme = Theme.of(context).colorScheme;
    final storedProvider = context.read<StoredProvider>();

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
            borderRadius: BorderRadius.circular(Config.CORNER.ROUNDEST),
          ),
        ),
      ),
      Autocomplete.Class(
        controller: _groupController,
        getOptions: () =>
            storedProvider.taskItems.whereType<GroupTask>().map((i) => i.name).toList(),
      ),
    ];

    return Container(
      width: 300,
      padding: Config.MARGIN_PADDING.MEDIUM,
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(Config.CORNER.ROUNDEST),
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

          Selector<CachedProvider, bool>(
            selector: (_, provider) => provider.dialogIndex == widget.index,
            builder: (context, visible, child) {
              return ActionRow.Class(
                visible: visible,
                buttons: [
                  ActionRow.Button(
                    text: 'Cancel',
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: colorScheme.error,
                    ),
                    callback: _close,
                  ),
                  ActionRow.Button(
                    text: 'Create',
                    style: TextButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    callback: _createTask,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();

    super.dispose();
  }

  void handleKey(RawKeyEvent event) {
    if (!mounted) return;
    if (context.read<CachedProvider>().dialogIndex != widget.index) return;
    if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) _createTask();
      if (event.logicalKey == LogicalKeyboardKey.escape) _close();
    }
  }

  void _close() {
    FocusScope.of(context).unfocus();
    context.read<CachedProvider>().dialogIndex = 0;

    _nameController.text = "";
    _groupController.text = "";
  }

  void _createTask([String? _]) {
    final storedProvider = context.read<StoredProvider>();

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

    final task = SingleTask(id: storedProvider.issueNewUUID(), name: name ?? '');

    Notify.send(
      context: context,
      title: "$name" + (groupName.isEmpty ? "" : " ($groupName)"),
      subtitle: "has been added to your todo list!",
      accentColor: Colors.green,
      duration: Config.NOTIFICATION.MEDIUM,
    );

    if (groupName.isEmpty) {
      storedProvider.addTaskItem(task);
    } else {
      final group = storedProvider.taskItems.whereType<GroupTask>().firstWhere(
        (g) => g.name == groupName,
        orElse: () {
          final group = GroupTask(
            id: storedProvider.issueNewUUID(),
            name: groupName,
            tasks: [],
          );
          storedProvider.addTaskItem(group);
          return group;
        },
      );

      storedProvider.addTaskToGroup(task, group);
    }

    _close();
  }
}
