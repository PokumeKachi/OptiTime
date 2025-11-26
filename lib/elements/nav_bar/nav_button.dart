import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/config.dart' as Config;

class Class extends StatelessWidget {
  const Class({super.key, required this.icon, required this.targetIndex});

  final IconData icon;
  final int targetIndex;

  static void handleClick(BuildContext context, int targetIndex) {
    debugPrint('Target index of navigation button is $targetIndex');
    final cachedProvider = context.read<CachedProvider>();

    cachedProvider.overlayIndex = cachedProvider.overlayIndex == targetIndex ? 0 : targetIndex;

    print(cachedProvider.overlayIndex);

    if (targetIndex == 0) {
      context.read<CachedProvider>().dialogIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Nav button rebuild');

    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: SizedBox.expand(
        child: Selector<CachedProvider, bool>(
          selector: (_, p) => p.overlayIndex == targetIndex,
          builder: (context, isFocused, child) {
            return AnimatedContainer(
              duration: Config.ANIMATION.SHORT,
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: isFocused ? colorScheme.tertiary : Colors.transparent,
                borderRadius: isFocused
                    ? BorderRadius.circular(Config.CORNER.SHARPEST)
                    : BorderRadius.circular(Config.CORNER.ROUNDEST),
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: colorScheme.inverseSurface.withOpacity(
                            Config.BLUR_OPACITY.MEDIUM,
                          ),
                          blurRadius: Config.BLUR_RADIUS.MEDIUM,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.transparent,
                          blurRadius: Config.BLUR_RADIUS.MEDIUM,
                        ),
                      ],
              ),
              child: TextButton(
                onPressed: () => handleClick(context, targetIndex),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: isFocused
                        ? BorderRadius.circular(Config.CORNER.SHARPEST)
                        : BorderRadius.circular(Config.CORNER.ROUNDEST),
                  ),
                  elevation: isFocused ? 32 : 0,
                  backgroundColor: Colors.transparent,
                  // backgroundColor: isFocused
                  //     ? colorScheme.tertiary
                  //     : Colors.transparent,
                  foregroundColor: isFocused
                      ? colorScheme.onTertiary
                      : colorScheme.onBackground,
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: Config.ICON_SIZE.MEDIUM,
                    end: isFocused
                        ? Config.ICON_SIZE.BIG
                        : Config.ICON_SIZE.SMALL,
                  ),
                  curve: Curves.easeOut,
                  duration: Config.ANIMATION.MEDIUM,
                  builder: (context, size, child) {
                    return Icon(icon, size: size);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
