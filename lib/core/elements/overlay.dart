import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:todo/pages/settings.dart' as SettingsPage;

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
        color: colorScheme.secondaryFixedDim,
        child: Center(child: Text('trash bin')),
      ),

      Container(
        color: colorScheme.primaryContainer,
        child: Center(child: Text('tree')),
      ),

      Container(
        color: colorScheme.tertiary,
        child: Center(child: Text('alarms')),
      ),

      SettingsPage.Class(),
    ];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.decelerate,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: Offset(
            (widget.pageIndex == 0)
                ? 0
                : (widget.pageIndex - pages.length / 2) * 0.8,
            (widget.pageIndex == 0)
                ? 0.8
                : (1.75 - (pages.length / 2 - widget.pageIndex).abs()) * 0.5,
          ),
          end: Offset.zero,
        ).animate(animation);
        final scale = Tween<double>(begin: 0.8, end: 1.0).animate(animation);
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
