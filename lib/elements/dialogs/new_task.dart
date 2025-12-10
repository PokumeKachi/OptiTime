import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo/l10n/app_localizations.dart';

import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/notify.dart' as Notify;
import 'package:todo/utils/stagger.dart' as Stagger;
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/data_type.dart';

import 'shared/provider.dart';
import 'shared/action_button.dart' as ActionButton;
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

  late final _nameShakeAnimation = Config.TWEEN.SHAKE.animate(
    CurvedAnimation(parent: _nameShakeController, curve: Curves.easeOut),
  );

  static const SPACING = Config.DIALOG.SPACING;

  @override
  void initState() {
    super.initState();

    widget.keyEventProvider.addListener(_handleKey);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameShakeController.dispose();
    _groupController.dispose();
    widget.keyEventProvider.removeListener(_handleKey);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('new task dialog rebuild');

    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    final itemProvider = context.read<SyncedProvider>();

    final inputBorder = ([bool focused = false]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(Config.CORNER.ROUND),
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: focused
            ? Config.BORDER_WIDTH.FOCUSED
            : Config.BORDER_WIDTH.MEDIUM,
      ),
    );

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
            labelText: loc.newTaskDialogTaskName,
            border: Config.getDialogInputBorder(context: context),
            enabledBorder: Config.getDialogInputBorder(context: context),
            focusedBorder: Config.getDialogInputBorder(context: context, focused: true),
          ),
        ),
      ),
      Autocomplete.Class(
        controller: _groupController,
        getOptions: () => itemProvider.items
            .whereType<GroupTask>()
            .map((i) => i.name)
            .toList(),
        labelText: loc.newTaskDialogTaskGroup,
      ),
    ].expand((widget) => [widget, const SizedBox(height: SPACING)]).toList();

    final actionButtonRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: Stagger.dialog(
        offset: -1.0,
        children: [
          ActionButton.Class(
            text: loc.buttonCancel,
            icon: Icon(Icons.cancel),
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: colorScheme.error,
            ),
            callback: _cancel,
          ),
          ActionButton.Class(
            text: loc.buttonCreate,
            icon: Icon(Icons.check),
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            callback: _create,
          ),
        ],
      ),
    );

    return Container(
      width: Config.DIALOG.WIDTH,
      padding: EdgeInsets.all(SPACING),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(Config.CORNER.ROUND),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            loc.newTaskDialogLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Config.FONT_SIZE.BIG,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Config.DIALOG.TITLE_PADDING),

          Selector<CachedProvider, bool>(
            selector: (_, provider) => provider.dialogIndex == widget.index,
            builder: (context, visible, child) => Visibility(
              visible: visible,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...Stagger.dialog(children: formWidgets),
                  actionButtonRow,
                ],
              ),
            ),
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
    final itemProvider = context.read<SyncedProvider>();

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
      final group = itemProvider.items.whereType<GroupTask>().firstWhere(
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
