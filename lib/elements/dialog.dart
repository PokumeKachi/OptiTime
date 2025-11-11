import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;
import 'dialogs/create_task.dart' as NewTask;

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  static final _dialogKeys = [GlobalKey<NewTask.ClassState>()];
  static final _dialogs = [
    const SizedBox.shrink(),
    NewTask.Class(key: _dialogKeys[0], index: 1),
  ];

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKey);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

  void _handleKey(RawKeyEvent event) {
    final dialogIndex = context.read<DialogIndexProvider>();

    if (dialogIndex.value != 0) {
      _dialogKeys[dialogIndex.value - 1].currentState?.handleKey(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('dialog rebuild');
    final dialogIndex = context.watch<DialogIndexProvider>().value;
    final colorScheme = Theme.of(context).colorScheme;
    final isDialogOpen = dialogIndex != 0;

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final portrait = height > width;

    return Center(
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: isDialogOpen ? 1 : 0,
            duration: Config.ANIMATION.MEDIUM,
            child: IgnorePointer(
              ignoring: !isDialogOpen,
              child: Container(
                color: colorScheme.scrim.withOpacity(Config.DIM.MEDIUM),
              ),
            ),
          ),
          ...List.generate(_dialogs.length - 1, (i) {
            final idx = i + 1;
            final active = dialogIndex == idx;
            return IgnorePointer(
              ignoring: !active,
              child: AnimatedSlide(
                offset: active ? Offset.zero : const Offset(0, -0.5),
                duration: Config.ANIMATION.MEDIUM,
                curve: Curves.easeInOutCubic,
                child: AnimatedScale(
                  scale: active ? 1 : 0.3,
                  duration: Config.ANIMATION.MEDIUM,
                  curve: Curves.easeInOutSine,
                  child: AnimatedOpacity(
                    opacity: active ? 1 : 0,
                    duration: Config.ANIMATION.MEDIUM,
                    child: Center(child: _dialogs[idx]),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
