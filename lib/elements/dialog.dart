import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;

import 'dialogs/shared/provider.dart';
import 'dialogs/new_task.dart' as NewTask;
import 'dialogs/sign_in.dart' as SignIn;
import 'dialogs/sign_out.dart' as SignOut;

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  static final keyEventProvider = KeyEventProvider();

  static final _dialogs = [
    const SizedBox.shrink(),
    NewTask.Class(index: 1, keyEventProvider: keyEventProvider),
    SignIn.Class(index: 2, keyEventProvider: keyEventProvider),
    SignOut.Class(index: 3, keyEventProvider: keyEventProvider),
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

  void _handleKey(RawKeyEvent event) => keyEventProvider.fire(event);

  @override
  Widget build(BuildContext context) {
    debugPrint('dialog rebuild');
    final dialogIndex = context.select<CachedProvider, int>(
      (c) => c.dialogIndex,
    );
    final colorScheme = Theme.of(context).colorScheme;
    final isDialogOpen = dialogIndex != 0;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<KeyEventProvider>.value(value: keyEventProvider),
      ],
      child: Center(
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: isDialogOpen ? 1 : 0,
              duration: Config.ANIMATION.MEDIUM,
              child: IgnorePointer(
                ignoring: !isDialogOpen,
                child: Container(
                  color: colorScheme.inverseSurface.withOpacity(Config.DIM.CLEARER),
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
                      child: Center(
                        // child: Container(
                        //   decoration: BoxDecoration(
                        //     // borderRadius: BorderRadius.circular(
                        //     //   Config.CORNER.ROUND,
                        //     // ),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: colorScheme.inverseSurface.withOpacity(
                        //           Config.BLUR_OPACITY.MEDIUM,
                        //         ),
                        //         blurRadius: Config.BLUR_RADIUS.MEDIUM,
                        //       ),
                        //     ],
                        //   ),
                        child: _dialogs[idx],
                        // ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
