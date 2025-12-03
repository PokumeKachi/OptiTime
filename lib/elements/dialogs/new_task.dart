import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo/l10n/app_localizations.dart';

import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/notify.dart' as Notify;
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/data_type.dart';

import 'shared/provider.dart';
import 'shared/action_row.dart' as ActionRow;
import 'shared/autocomplete.dart' as Autocomplete;

class Class extends StatefulWidget {
  final int index;
  final KeyEventProvider keyEventProvider;

  const Class({super.key, required this.index, required this.keyEventProvider});

  @override
  State<Class> createState() => ClassState();
}

class ClassState extends State<Class> with SingleTickerProviderStateMixin {
  late final _nameController = TextEditingController();
  late final _groupController = TextEditingController();

  late final _nameShakeController = AnimationController(
    vsync: this,
    duration: Config.ANIMATION.MEDIUM,
  );

  late final _nameShakeAnimation =
      Config.TWEEN.SHAKE.animate(
        CurvedAnimation(parent: _nameShakeController, curve: Curves.easeOut),
      );

  @override
  void initState() {
    super.initState();

    widget.keyEventProvider.addListener(_handleKey);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    widget.keyEventProvider.removeListener(_handleKey);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('new task dialog rebuild');

    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    final itemProvider = context.read<ItemProvider>();

    final formWidgets = [
      AnimatedBuilder(
        animation: _nameShakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_nameShakeAnimation.value, 0),
            child: child,
          );
        },
        child: TextField(
          controller: _nameController,
          decoration: InputDecoration(
            // labelText: 'Name',
            labelText: loc.newTaskDialogTaskName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Config.CORNER.ROUND),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Config.CORNER.ROUND),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: Config.BORDER_WIDTH.MEDIUM,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Config.CORNER.ROUND),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: Config.BORDER_WIDTH.FOCUSED,
              ),
            ),
          ),
        ),
      ),
      Autocomplete.Class(
        controller: _groupController,
        getOptions: () => itemProvider.list
            .whereType<GroupTask>()
            .map((i) => i.name)
            .toList(),
        labelText: loc.newTaskDialogTaskGroup,
      ),
    ];

    return Container(
      width: 300,
      padding: Config.MARGIN_PADDING.MEDIUM,
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(Config.CORNER.ROUND),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            loc.newTaskDialogTitle,
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
                    text: loc.buttonCancel,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: colorScheme.error,
                    ),
                    callback: _cancel,
                  ),
                  ActionRow.Button(
                    text: loc.buttonCreate,
                    style: TextButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    callback: _create,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleKey() {
    if (!mounted) return;
    if (context.read<CachedProvider>().dialogIndex != widget.index) return;

    final event = widget.keyEventProvider.lastEvent;
    if (event == null) return;

    if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) _create();
      if (event.logicalKey == LogicalKeyboardKey.escape) _cancel();
    }
  }

  void _cancel() {
    FocusScope.of(context).unfocus();
    context.read<CachedProvider>().dialogIndex = 0;

    _nameController.text = "";
    _groupController.text = "";
  }

  void _missingWarning(AnimationController controller) {
    controller.forward(from: 0);
  }

  void _create([String? _]) {
    final loc = AppLocalizations.of(context)!;
    final itemProvider = context.read<ItemProvider>();

    final name = _nameController.text;
    final groupName = _groupController.text;
    debugPrint('Creating a new task from the dialog');
    debugPrint('Name: $name');
    debugPrint('Group: $groupName');

    if (name.isEmpty) {
      _missingWarning(_nameShakeController);
      return;
    }

    final task = SingleTask(uuid: itemProvider.issueNewUUID(), name: name);

    Notify.send(
      context: context,
      title: "$name${groupName.isEmpty ? '' : ' ($groupName)'}",
      subtitle: loc.newTaskNotificationSubtitle,
      accentColor: Colors.green,
      duration: Config.NOTIFICATION.MEDIUM,
    );

    if (groupName.isEmpty) {
      itemProvider.add(task);
    } else {
      final group = itemProvider.list.whereType<GroupTask>().firstWhere(
        (g) => g.name == groupName,
        orElse: () {
          final group = GroupTask(
            uuid: itemProvider.issueNewUUID(),
            name: groupName,
            tasks: [],
          );
          itemProvider.add(group);
          return group;
        },
      );

      itemProvider.addToGroup(task, group);
    }

    _cancel();
  }
}
