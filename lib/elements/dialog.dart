import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/provider.dart';
import 'dialogs/create_task.dart' as NewTask;

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  late final List<Widget> _dialogs;

  @override
  void initState() {
    super.initState();
    _dialogs = [const SizedBox.shrink(), NewTask.Class(index: 1)];
  }

  void _closeDialog(BuildContext context) {
    final provider = context.read<DialogIndexProvider>();
    if (provider.value != 0) {
      FocusScope.of(context).unfocus();
      provider.value = 0;
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
                color: colorScheme.scrim.withOpacity(Config.DIM_OPACITY),
              ),
            ),
          ),
          if (isDialogOpen)
            GestureDetector(
              onTap: () => _closeDialog(context),
              child: const ColoredBox(
                color: Colors.transparent,
                child: SizedBox.expand(),
              ),
            ),
          ...List.generate(_dialogs.length - 1, (i) {
            final idx = i + 1;
            final active = dialogIndex == idx;
            return IgnorePointer(
              ignoring: !active,
              child: AnimatedSlide(
                offset: active
                    ? Offset.zero
                    // : Offset(portrait ? 0 : -0.5, (!portrait) ? 0 : -0.5),
                    : const Offset(0, -0.5),
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
