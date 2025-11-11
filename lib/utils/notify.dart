
import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:todo/utils/config.dart' as Config;

void send({
  required BuildContext context,
  String content = "",
  Color accentColor = Colors.green,
  Duration duration = Config.NOTIFICATION.MEDIUM,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final hslAccent = HSLColor.fromColor(accentColor);
  final lightness = HSLColor.fromColor(colorScheme.tertiary).lightness;

  final textColor = isDark ? Colors.white : Colors.black;

  final backgroundColor = isDark
      ? HSLColor.fromAHSL(
          1.0,
          hslAccent.hue,
          hslAccent.saturation * 0.5,
          1 - lightness,
        ).toColor()
      : Colors.white;

  final borderColor = HSLColor.fromAHSL(
    1.0,
    hslAccent.hue,
    0.75,
    0.5,
  ).toColor();

  AnimatedSnackBar(
    duration: Config.NOTIFICATION.MEDIUM,

    mobileSnackBarPosition : MobileSnackBarPosition.top,
    desktopSnackBarPosition : DesktopSnackBarPosition.bottomLeft,
    snackBarStrategy: ColumnSnackBarStrategy(),
    animationDuration: Config.ANIMATION.MEDIUM,
    animationCurve: Curves.easeInOutCubicEmphasized,

    
    builder: ((context) {
      return Container(
        padding: Config.MARGIN_PADDING.NARROW,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: Config.BORDER_WIDTH * 2,
          ),
          borderRadius: BorderRadius.circular(Config.CORNER.MEDIUM),
          boxShadow: [
            BoxShadow(
              color: colorScheme.scrim.withOpacity(0.5),
              blurRadius: 16,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.info, color: accentColor),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'yela',
                  style: TextStyle(
                    color: textColor,
                    fontSize: Config.FONT_SIZE.BIG,
                  ),
                ),
                Text(
                  'no',
                  style: TextStyle(
                    color: textColor,
                    fontSize: Config.FONT_SIZE.MEDIUM,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }),
  ).show(context);
}

