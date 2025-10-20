import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'overlays/settings.dart' as SettingsPage;
import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/provider.dart';

class Class extends StatelessWidget {
  const Class({super.key});

  static final pages = [
    Container(),
    Center(child: Text('trash bin')),
    Center(child: Text('tree')),
    Center(child: Text('alarms')),
    const SettingsPage.Class(),
  ];

  static final medianIndex = pages.length / 2;

  @override
  Widget build(BuildContext context) {
    final overlayIndex = context.watch<OverlayIndexProvider>().overlayIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dimOpacity = isDark ? 0.8 : 0.3;

    return Stack(
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: Config.ANIMATION_DURATION),
          opacity: overlayIndex == 0 ? 0 : 1,
          child: IgnorePointer(
            ignoring: overlayIndex == 0,
            child: Container(color: Colors.black.withOpacity(dimOpacity)),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: Config.ANIMATION_DURATION),
          switchInCurve: Curves.decelerate,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final opened = overlayIndex != 0;

            final height = MediaQuery.of(context).size.height;
            final width = MediaQuery.of(context).size.width;
            final portraitView = height > width;

            final dx = portraitView
                ? (opened ? (overlayIndex - medianIndex) * 0.8 : 0.0)
                : 0.5;
            final dy = opened
                ? (1.75 - (medianIndex - overlayIndex).abs()) * 0.3
                : 0.5;

            final slide = Tween<Offset>(begin: Offset(dx, dy), end: Offset.zero)
                .animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                );
            final scale = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            );

            return SlideTransition(
              position: slide,
              child: ScaleTransition(
                scale: scale,
                child: FadeTransition(opacity: animation, child: child),
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(overlayIndex),
            child: pages[overlayIndex],
          ),
        ),
      ],
    );
  }
}
