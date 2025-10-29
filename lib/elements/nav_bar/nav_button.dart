import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/config.dart' as Config;

class Class extends StatelessWidget {
  const Class({super.key, required this.icon, this.targetIndex});

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
      overlayIndex.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCenter = targetIndex == null;

    return Expanded(
      child: SizedBox.expand(
        child: TextButton(
          onPressed: () => handleClick(context, targetIndex),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Config.CORNER.MIN),
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
            icon,
            size: isCenter ? Config.ICON_SIZE.BIG : Config.ICON_SIZE.MEDIUM,
          ),
        ),
      ),
    );
  }
}
