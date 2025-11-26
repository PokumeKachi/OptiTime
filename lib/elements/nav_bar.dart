import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/config.dart' as Config;

import 'nav_bar/nav_button.dart' as NavButton;

class Class extends StatelessWidget {
  const Class({super.key});

  static const navItems = [
    {'icon': Icons.delete, 'target': 1},
    {'icon': Icons.energy_savings_leaf, 'target': 2},
    {'icon': Icons.add, 'target': 0},
    {'icon': Icons.notifications, 'target': 3},
    {'icon': Icons.settings, 'target': 4},
  ];

  static final List<Widget> _cachedButtons = navItems.map((item) {
    final target = item['target'] as int;
    return NavButton.Class(icon: item['icon'] as IconData, targetIndex: target);
  }).toList();

  @override
  Widget build(BuildContext context) {
    debugPrint('navbar rebuild');

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final portraitView = height > width;

    return Positioned(
      left: portraitView ? 0 : null,
      top: (!portraitView) ? 0 : null,
      right: 0,
      bottom: 0,
      child: SizedBox(
        height: portraitView ? height * Config.NAV_BAR_RATIO : double.infinity,
        width: (!portraitView) ? width * Config.NAV_BAR_RATIO : double.infinity,
        child: Flex(
          direction: portraitView ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: portraitView
              ? _cachedButtons
              : _cachedButtons.reversed.toList(),
        ),
      ),
    );
  }
}
