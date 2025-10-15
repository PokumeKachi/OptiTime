import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:todo/overlays/settings.dart' as SettingsPage;
import 'package:todo/core/config.dart' as Config;

class Class extends StatefulWidget {
  const Class({super.key, required this.pageIndex});

  final pageIndex;

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final pages = [
      Container(),

      Container(
        color: Color.fromRGBO(130, 20, 20, 1),
        child: Center(child: Text('trash bin')),
      ),

      Container(
        color: colorScheme.primaryContainer,
        child: Center(child: Text('tree')),
      ),

      Container(
        color: colorScheme.onTertiaryFixedVariant,
        child: Center(child: Text('alarms')),
      ),

      SettingsPage.Class(),
    ];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: Config.ANIMATION_DURATION),
      switchInCurve: Curves.decelerate,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        final center = pages.length / 2;
        final isFirst = widget.pageIndex == 0;

        final dx = isFirst ? 0.0 : (widget.pageIndex - center) * 0.8;
        final dy = isFirst
            ? 0.5
            : (1.75 - (center - widget.pageIndex).abs()) * 0.3;

        final slide = Tween<Offset>(
          begin: Offset(dx, dy),
          end: Offset.zero,
        ).animate(animation);
        final scale = Tween<double>(begin: 0.5, end: 1.0).animate(animation);
        final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

        return SlideTransition(
          position: slide,
          child: ScaleTransition(
            scale: scale,
            child: FadeTransition(opacity: opacity, child: child),
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(widget.pageIndex),
        child: pages[widget.pageIndex],
      ),
    );
  }
}
