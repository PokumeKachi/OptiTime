import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/config.dart' as Config;

import 'nav_bar/nav_button.dart' as NavButton;

class Class extends StatelessWidget {
  const Class({super.key});

  static const navItems = [
    {'icon': Icons.delete_outlined, 'target': 1},
    {'icon': Icons.star_border, 'target': 2},
    {'icon': Icons.add, 'target': 0},
    {'icon': Icons.notifications_outlined, 'target': 3},
    {'icon': Icons.settings_outlined, 'target': 4},
  ];

  static final List<Widget> _cachedButtons = navItems.map((item) {
    final target = item['target'] as int;
    return NavButton.Class(icon: item['icon'] as IconData, targetIndex: target);
  }).toList();

  @override
  Widget build(BuildContext context) {
    debugPrint('navbar rebuild');

    final HEIGHT = MediaQuery.of(context).size.height;
    final WIDTH = MediaQuery.of(context).size.width;
    final PORTRAIT = HEIGHT > WIDTH;

    final locked = context.select<CachedProvider, bool>(
      (p) => p.focusDuration != null,
    );

    if (locked) return SizedBox.shrink();

    return Positioned(
      left: PORTRAIT ? 0 : null,
      top: (!PORTRAIT) ? 0 : null,
      right: 0,
      bottom: 0,
      child: SizedBox(
        height: PORTRAIT ? HEIGHT * Config.NAV_BAR_RATIO : double.infinity,
        width: (!PORTRAIT) ? WIDTH * Config.NAV_BAR_RATIO : double.infinity,
        child: Flex(
          direction: PORTRAIT ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: PORTRAIT
              ? _cachedButtons
              : _cachedButtons.reversed.toList(),
        ),
      ),
    );
  }
}
