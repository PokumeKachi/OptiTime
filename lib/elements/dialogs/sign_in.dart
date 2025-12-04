import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo/l10n/app_localizations.dart';

import 'package:todo/utils/supabase.dart' as _Supabase;
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

class ClassState extends State<Class> with TickerProviderStateMixin {
  late final _usernameController = TextEditingController();
  late final _passwordController = TextEditingController();

  late final _usernameShakeController = AnimationController(
    vsync: this,
    duration: Config.ANIMATION.MEDIUM,
  );

  late final _usernameShakeAnimation = Config.TWEEN.SHAKE.animate(
    CurvedAnimation(parent: _usernameShakeController, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();

    widget.keyEventProvider.addListener(_handleKey);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
        animation: _usernameShakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_usernameShakeAnimation.value, 0),
            child: child,
          );
        },
        child: TextField(
          controller: _usernameController,
          decoration: InputDecoration(
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
      AnimatedBuilder(
        animation: _usernameShakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_usernameShakeAnimation.value, 0),
            child: child,
          );
        },
        child: TextField(
          controller: _usernameController,
          decoration: InputDecoration(
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
              if (!visible) {
                return SizedBox();
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: Stagger.dialog(
                      children: [
                        for (final widget in formWidgets) ...[
                          widget,
                          const SizedBox(height: Config.ITEM_PADDING.MEDIUM),
                        ],
                      ],
                    ),
                  ),
                  Row(
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
                          callback: _confirm,
                        ),
                        ActionButton.Class(
                          text: loc.buttonCreate,
                          icon: Icon(Icons.check),
                          style: TextButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          callback: _confirm,
                        ),
                      ],
                    ),
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
      if (event.logicalKey == LogicalKeyboardKey.escape) _confirm();
    }
  }

  void _confirm() {
    FocusScope.of(context).unfocus();
    context.read<CachedProvider>().dialogIndex = 0;

    _usernameController.text = "";
    _passwordController.text = "";
  }

  void _missingWarning(AnimationController controller) {
    controller.forward(from: 0);
  }

  void _create([String? _]) {
    // final loc = AppLocalizations.of(context)!;
    // final itemProvider = context.read<ItemProvider>();
    //
    // final username = _usernameController.text;
    // final passwordName = _passwordController.text;
    // debugPrint('Creating a new task from the dialog');
    // debugPrint('Name: $username');
    // debugPrint('Group: $passwordName');
    //
    // if (username.isEmpty) {
    //   _missingWarning(_usernameShakeController);
    //   return;
    // }
    //
    // final task = SingleTask(uuid: itemProvider.issueNewUUID(), username: username);
    //
    // Notify.send(
    //   context: context,
    //   title: "$username${passwordName.isEmpty ? '' : ' ($passwordName)'}",
    //   subtitle: loc.newTaskNotificationSubtitle,
    //   accentColor: Colors.green,
    //   duration: Config.NOTIFICATION.MEDIUM,
    // );
    //
    // if (passwordName.isEmpty) {
    //   itemProvider.add(task);
    // } else {
    //   final password = itemProvider.list.whereType<GroupTask>().firstWhere(
    //     (g) => g.username == passwordName,
    //     orElse: () {
    //       final password = GroupTask(
    //         uuid: itemProvider.issueNewUUID(),
    //         username: passwordName,
    //         tasks: [],
    //       );
    //       itemProvider.add(password);
    //       return password;
    //     },
    //   );
    //
    //   itemProvider.addToGroup(task, password);
    // }
    //
    // _cancel();
  }
}
