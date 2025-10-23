import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/provider.dart';
import 'dialog.dart' as Dialogs;

class _NavButton extends StatefulWidget {
  const _NavButton({super.key, required this.icon, this.targetIndex});

  final IconData icon;
  final int? targetIndex;

  static void handleClick(BuildContext context, int? targetIndex) {
    debugPrint('Target index of navigation button is $targetIndex');
    final overlayIndex = context.read<OverlayIndexProvider>();
    final dialogIndex = context.read<DialogIndexProvider>();

    if (targetIndex != null) {
      overlayIndex.value = overlayIndex.value == targetIndex ? 0 : targetIndex;
    } else {
      dialogIndex.value = 1;
    }
  }

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCenter = widget.targetIndex == null;

    return Expanded(
      child: SizedBox.expand(
        child: TextButton(
          onPressed: () => _NavButton.handleClick(context, widget.targetIndex),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Config.MIN_CORNER),
            ),
            elevation: isCenter ? 32 : 0,
            backgroundColor: isCenter
                ? colorScheme.primary
                : Colors.transparent,
            foregroundColor: isCenter
                ? colorScheme.onPrimary
                : colorScheme.primary,
          ),
          child: Icon(
            widget.icon,
            size: isCenter ? Config.ICON_SIZE.BIG : Config.ICON_SIZE.MEDIUM,
          ),
        ),
      ),
    );
  }
}

class Class extends StatelessWidget {
  const Class({super.key});

  static const navItems = [
    {'icon': Icons.delete, 'target': 1},
    {'icon': Icons.energy_savings_leaf, 'target': 2},
    {'icon': Icons.add, 'target': null},
    {'icon': Icons.notifications, 'target': 3},
    {'icon': Icons.settings, 'target': 4},
  ];

  static final List<Widget> _cachedButtons = navItems.map((item) {
    final target = item['target'] as int?;
    return _NavButton(icon: item['icon'] as IconData, targetIndex: target);
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
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: portraitView
              ? height * Config.NAV_BAR_RATIO
              : double.infinity,
          width: (!portraitView)
              ? width * Config.NAV_BAR_RATIO
              : double.infinity,
          child: Flex(
            direction: portraitView ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: portraitView
                ? _cachedButtons
                : _cachedButtons.reversed.toList(),
          ),
        ),
      ),
    );
  }
}
