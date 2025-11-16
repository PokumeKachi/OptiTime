import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:todo/utils/config.dart' as Config;

void send({
  required BuildContext context,
  String title = "",
  String subtitle = "",
  Color accentColor = Colors.green,
  Duration duration = Config.NOTIFICATION.MEDIUM,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final hslAccent = HSLColor.fromColor(accentColor);
  final tertiaryLightness = HSLColor.fromColor(colorScheme.tertiary).lightness;
  final textColor = isDark ? Colors.white : Colors.black;
  final backgroundColor = isDark
      ? hslAccent
            .withSaturation(hslAccent.saturation * 0.5)
            .withLightness(1 - tertiaryLightness)
            .toColor()
      : Colors.white;
  final borderColor = hslAccent.withLightness(0.7).toColor();

  late final AnimatedSnackBar snackBar;

  snackBar = AnimatedSnackBar(
    duration: duration,
    mobilePositionSettings: const MobilePositionSettings(
      topOnAppearance: 10,
      left: 10,
      right: 10,
    ),
    desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
    snackBarStrategy: ColumnSnackBarStrategy(),
    animationDuration: Config.ANIMATION.SHORT,
    animationCurve: Curves.easeInOutCubicEmphasized,
    builder: (context) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => snackBar.remove(),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Config.ANIMATION.EXTREMELY_LONG,
            curve: Curves.easeOut,
            builder: (BuildContext context, double t, _) {
              final iconSize = lerpDouble(
                Config.ICON_SIZE.VERY_BIG,
                Config.ICON_SIZE.MEDIUM,
                t,
              );
              return Container(
                padding: Config.MARGIN_PADDING.NARROW,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(accentColor, backgroundColor, t)!,
                      Color.lerp(
                        backgroundColor,
                        accentColor,
                        t * Config.NOTIFICATION_GRADIENT_RATIO,
                      )!,
                    ],
                  ),
                  border: Border.all(
                    color:
                        Color.lerp(Colors.white, borderColor, t) ?? borderColor,
                    width: Config.BORDER_WIDTH * 2 * t,
                  ),
                  borderRadius: BorderRadius.circular(Config.CORNER.MEDIUM * t),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.scrim.withOpacity(0.2),
                      blurRadius: 16 * t,
                      spreadRadius: 2 * t,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.info, size: iconSize, color: accentColor),
                    SizedBox(width: 8 * t),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.substring(0, (title.length * t).floor()),
                            style: TextStyle(
                              color: Color.lerp(
                                accentColor,
                                hslAccent
                                    .withLightness(isDark ? 0.7 : 0.3)
                                    .toColor(),
                                t,
                              ),
                              fontSize: Config.FONT_SIZE.BIG,
                            ),
                          ),
                          Text(
                            subtitle.substring(
                              0,
                              (subtitle.length * t).floor(),
                            ),
                            style: TextStyle(
                              color: Color.lerp(backgroundColor, textColor, t),
                              fontSize: Config.FONT_SIZE.MEDIUM,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );

  snackBar.show(context);
}
