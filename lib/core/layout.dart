import 'package:flutter/material.dart';

import 'elements/body.dart' as Body;
import 'elements/nav_bar.dart' as NavBar;
import 'elements/overlay.dart' as Overlay;

import 'config.dart' as Config;

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  final pageIndex = ValueNotifier<int>(0);

  void onNavigationButtonClick(int? targetIndex) {
    if (targetIndex == null) {
      return;
    }

    pageIndex.value = (pageIndex.value == targetIndex) ? 0 : targetIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Body.Class(),

          ValueListenableBuilder<int>(
            valueListenable: pageIndex,
            builder: (context, value, __) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final color = Colors.black.withOpacity(isDark ? 0.3 : 0.5);

              return AnimatedOpacity(
                duration: const Duration(milliseconds: Config.ANIMATION_DURATION),
                opacity: value == 0 ? 0.0 : 1.0,
                child: IgnorePointer(
                  ignoring: value == 0,
                  child: Container(color: color),
                ),
              );
            },
          ),

          ValueListenableBuilder<int>(
            valueListenable: pageIndex,
            builder: (_, value, __) => Overlay.Class(pageIndex: value),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: NavBar.Class(clickEvent: onNavigationButtonClick),
            ),
          ),
        ],
      ),
    );
  }
}
