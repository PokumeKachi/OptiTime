import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/data_types.dart';

import 'package:todo/utils/config.dart' as Config;
import 'task.dart' as Task;

int randomRange(Random rnd, int min, int max) =>
    rnd.nextInt(max - min + 1) + min;

class SHIFT {
  static const HUE = 50;
  static const SAT = 0.1;
  static const LIGHT = 0.0;
}

Color randomVariant(Color base, int? seed) {
  final hsl = HSLColor.fromColor(base);
  final rnd = Random(seed);

  final hueShift = (rnd.nextDouble() * SHIFT.HUE * 2 - SHIFT.HUE);
  final satShift = (rnd.nextDouble() * SHIFT.SAT * 2 - SHIFT.SAT);
  final lightShift =
      (hsl.lightness - 0.5) *
          -0.5 // make the color darker if it is light and vice versa
          +
      (rnd.nextDouble() * SHIFT.LIGHT * 2 - SHIFT.LIGHT);
  // (rnd.nextDouble() * SHIFT.LIGHT * 3 - SHIFT.LIGHT); // +/-15% lightness

  final computedHue = hsl.hue + hueShift;
  final computedSat = hsl.saturation + satShift;
  final computedLight = hsl.lightness + lightShift;

  return hsl
      .withHue(computedHue % 360)
      .withSaturation(computedSat.clamp(0.0, 1.0))
      .withLightness(computedLight.clamp(0.0, 1.0))
      .toColor();
}

Color randomizeColor(
  Color color, [
  int varianceRed = 10,
  int varianceGreen = 10,
  int varianceBlue = 10,
  int factor = 1,
  int? seed,
]) {
  final rnd = Random(seed);
  int clamp(int val) => val.clamp(0, 255);
  return Color.fromARGB(
    color.alpha,
    clamp(color.red + randomRange(rnd, -varianceRed, varianceRed) * factor),
    clamp(
      color.green + randomRange(rnd, -varianceGreen, varianceGreen) * factor,
    ),
    clamp(color.blue + randomRange(rnd, -varianceBlue, varianceBlue) * factor),
  );
}

class Class extends StatelessWidget {
  const Class({super.key, required this.group});

  final TaskGroup group;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        // color: randomizeColor(colorScheme.secondary, 20, 20, 5, 2, group.name.hashCode),
        // color: randomVariant(colorScheme.secondary, group.name.hashCode),
        color: colorScheme.tertiary,
        borderRadius: BorderRadius.circular(Config.CORNER.MEDIUM),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  randomVariant(colorScheme.tertiary, group.name.hashCode),
                  colorScheme.tertiary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // stops: [0.0, 0.5],
              ),
              borderRadius: BorderRadius.circular(Config.CORNER.MEDIUM),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Center(
              child: Text(
                '${group.name}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Config.FONT_SIZE.BIG,
                ),
              ),
            ),
          ),
          // Text(
          //   '${group.name}',
          //   style: TextStyle(
          //     color: colorScheme.onSecondary,
          //     fontSize: Config.FONT_SIZE.BIG,
          //   ),
          // ),
          for (final task in group.tasks) ...[Task.Class(task: task)],
        ],
      ),
    );
  }
}
