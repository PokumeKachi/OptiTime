import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/task.dart';
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/config.dart' as Config;

import 'dialogs/create_task.dart' as NewTask;

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  static final List<Widget> _dialogs = [const SizedBox.shrink()];
  static final _dialogConstructors = [
    (int index) => NewTask.Class(index: index),
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _dialogConstructors.length; i++) {
      _dialogs.add(_dialogConstructors[i](i + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('dialog rebuild');

    final dialogIndex = context.watch<DialogIndexProvider>().value;
    final colorScheme = Theme.of(context).colorScheme;

    debugPrint('Current dialog index is $dialogIndex');

    return Center(
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: dialogIndex == 0 ? 0 : 1,
            duration: const Duration(milliseconds: Config.ANIMATION_DURATION),
            child: IgnorePointer(
              ignoring: dialogIndex == 0,
              child: Container(color: colorScheme.scrim.withOpacity(Config.DIM_OPACITY)),
            ),
          ),

          if (dialogIndex != 0)
            GestureDetector(
              onTap: () => context.read<DialogIndexProvider>().value = 0,
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(
                  milliseconds: Config.ANIMATION_DURATION,
                ),
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

          for (int i = 1; i < _dialogs.length; i++) ...[
            IgnorePointer(
              ignoring: dialogIndex != i,
              child: AnimatedSlide(
                offset: (dialogIndex == i) ? Offset.zero : const Offset(0, -.5),
                duration: const Duration(
                  milliseconds: Config.ANIMATION_DURATION,
                ),
                curve: Curves.easeInOutCubic,
                child: AnimatedScale(
                  scale: (dialogIndex == i) ? 1 : 0.3,
                  duration: const Duration(
                    milliseconds: Config.ANIMATION_DURATION,
                  ),
                  curve: Curves.easeInOutSine,
                  child: AnimatedOpacity(
                    opacity: (dialogIndex == i) ? 1 : 0,
                    duration: const Duration(
                      milliseconds: Config.ANIMATION_DURATION,
                    ),
                    child: Center(child: _dialogs[i]),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
