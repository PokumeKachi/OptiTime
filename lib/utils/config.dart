import 'package:flutter/material.dart';

// Core properties

const TITLE = 'Todo';
const PRELOAD_DURATION = Duration(milliseconds: 200);

// Color scheming

// const SEED_COLOR = Color.fromRGBO(225, 215, 125, 1);
const SEED_COLOR = Colors.teal;
final ColorScheme COLOR_SCHEME = ColorScheme.fromSeed(seedColor: SEED_COLOR);

// final ColorScheme COLOR_SCHEME = ColorScheme(
//   primary: SEED_COLOR,
//   onPrimary: Colors.black,
//   secondary: Colors.orange,
//   onSecondary: Colors.white,
//   background: Colors.white,
//   onBackground: Colors.black,
//   surface: Colors.white,
//   onSurface: Colors.black,
//   error: Colors.red,
//   onError: Colors.white,
// );

final ColorScheme COLOR_SCHEME_DARK = ColorScheme.fromSeed(
  seedColor: SEED_COLOR,
  brightness: Brightness.dark,
);

const NOTIFICATION_GRADIENT_RATIO = 0.2;

final ThemeData THEME = ThemeData.from(colorScheme: COLOR_SCHEME);
final ThemeData THEME_DARK = ThemeData.from(colorScheme: COLOR_SCHEME_DARK);

// const DIM.MEDIUM = 0.7;
class DIM {
  static const NONE = 0.0;
  static const MEDIUM = 0.5;
  static const NEAR_SOLID = 0.9;
  static const SOLID = 1.0;
}

// Element sizing

const NAV_BAR_RATIO = 0.08;
const DIALOG_RATIO = 0.8;

class FONT_SIZE {
  static const SMALL = 12.0;
  static const MEDIUM = 16.0;
  static const BIG = 24.0;
}

class ICON_SIZE {
  static const SMALL = 16.0;
  static const MEDIUM = 24.0;
  static const BIG = 32.0;
  static const VERY_BIG = 36.0;
}

// Element positioning

class MARGIN_PADDING {
  static const NONE = 0.0;
  static const NARROW = EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0);
  static const MEDIUM = EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0);
  static const WIDE = EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0);
}

class ITEM_PADDING {
  static const NONE = 0.0;
  static const NARROW = 8.0;
  static const MEDIUM = 12.0;
  static const WIDE = 16.0;
}

const SOME_RANDOM_AHH_TEXT_FIELD_PADDING_SHIT = 12.0;

// Element decorating

class ELEVATION {
  static const NONE = 0.0;
  static const LOW = 4.0;
  static const MEDIUM = 8.0;
  static const HIGH = 12.0;
}

class CORNER {
  static const NONE = 0.0;
  static const MIN = 4.0;
  static const MEDIUM = 10.0;
  static const ROUNDER = 16.0;
  static const ROUNDEST = 20.0;
}

class BLUR_OPACITY {
  static const MEDIUM = 0.7;
}

class BLUR_RADIUS {
  static const MEDIUM = 32.0;
}

const BORDER_WIDTH = 1.0;
const FOCUSED_BORDER_WIDTH = 2.0;

// Animation

class ANIMATION {
  static const NONE = const Duration(milliseconds: 0);
  static const SHORT = const Duration(milliseconds: 150);
  static const MEDIUM = const Duration(milliseconds: 300);
  static const LONG = const Duration(milliseconds: 450);
  static const VERY_LONG = const Duration(milliseconds: 600);
}

class NOTIFICATION {
  static const NONE = const Duration(seconds: 0);
  static const SHORT = const Duration(seconds: 2);
  static const MEDIUM = const Duration(seconds: 5);
  static const LONG = const Duration(seconds: 10);
  static const VERY_LONG = const Duration(seconds: 15);
}

class BOBBING_SCALE {
  static const NONE = 0.0;
  static const MILD = 0.99;
  static const MEDIUM = 0.95;
  static const AGGRESSIVE = 0.9;
}
