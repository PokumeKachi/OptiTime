import 'package:flutter/material.dart';

// Core properties

const TITLE = 'Todo';
const PRELOAD_DURATION = Duration(milliseconds: 200);
const SCROLL_PHYSICS = const BouncingScrollPhysics(
  parent: AlwaysScrollableScrollPhysics(),
);

// const SCROLL_PHYSICS = const AlwaysScrollableScrollPhysics();
// final SCROLL_PHYSICS = BouncingScrollPhysics().applyTo(const ClampingScrollPhysics());
// final SCROLL_PHYSICS = FixedExtentScrollPhysics();


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

const NOTIFICATION_GRADIENT_RATIO = 0.1;

final ThemeData THEME = ThemeData.from(colorScheme: COLOR_SCHEME);
final ThemeData THEME_DARK = ThemeData.from(colorScheme: COLOR_SCHEME_DARK);

// const DIM.MEDIUM = 0.7;
class DIM {
  static const NONE = 0.0;
  static const MEDIUM = 0.5;
  static const NEAR_SOLID = 0.9;
  static const SOLID = 1.0;
}

// Element positioning

// class MARGIN_PADDING {
//   static const NONE = 0.0;
//   static const NARROWEST = EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0);
//   static const NARROWER = EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0);
//   static const NARROW = EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0);
//   static const MEDIUM = EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0);
//   static const WIDE = EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0);
//   static const WIDER = EdgeInsets.fromLTRB(48.0, 24.0, 48.0, 24.0);
// }

class ITEM_PADDING {
  static const NONE = 0.0;
  static const NARROWEST = 4.0;
  static const NARROWER = 8.0;
  static const NARROW = 12.0;
  static const MEDIUM = 16.0;
  static const WIDE = 24.0;
  static const WIDER = 32.0;
  static const WIDEST = 48.0;
}

class MARGIN_PADDING {
  static const NONE = EdgeInsets.all(ITEM_PADDING.NONE);
  static const NARROWEST = EdgeInsets.all(ITEM_PADDING.NARROWEST);
  static const NARROWER = EdgeInsets.all(ITEM_PADDING.NARROWER);
  static const NARROW = EdgeInsets.all(ITEM_PADDING.NARROW);
  static const MEDIUM = EdgeInsets.all(ITEM_PADDING.MEDIUM);
  static const WIDE = EdgeInsets.all(ITEM_PADDING.WIDE);
  static const WIDER = EdgeInsets.all(ITEM_PADDING.WIDER);
  static const WIDEST = EdgeInsets.all(ITEM_PADDING.WIDEST);
}

const SOME_RANDOM_AHH_TEXT_FIELD_PADDING_SHIT = 12.0;

// Element sizing

const NAV_BAR_RATIO = 0.07;
const DIALOG_RATIO = 0.8;
const TASK_ITEM_MAX_WIDTH = 200.0;

const MAIN_BODY_MARGIN = ITEM_PADDING.WIDE;

class FONT_SIZE {
  static const SMALL = 12.0;
  static const MEDIUM = 16.0;
  static const BIG = 24.0;
}

class ICON_SIZE {
  static const VERY_SMALL = 12.0;
  static const SMALL = 18.0;
  static const MEDIUM = 24.0;
  static const BIG = 32.0;
  static const VERY_BIG = 36.0;
}

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

// Timing

class ANIMATION {
  static const NONE = const Duration(milliseconds: 0);
  static const SHORT = const Duration(milliseconds: 150);
  static const MEDIUM = const Duration(milliseconds: 300);
  static const LONG = const Duration(milliseconds: 450);
  static const VERY_LONG = const Duration(milliseconds: 600);
  static const VERY_LONGER = const Duration(milliseconds: 750);
  static const EXTREMELY_LONG = const Duration(milliseconds: 900);
}

class NOTIFICATION {
  static const NONE = const Duration(seconds: 0);
  static const SHORT = const Duration(seconds: 5);
  static const MEDIUM = const Duration(seconds: 15);
  static const LONG = const Duration(seconds: 30);
  static const VERY_LONG = const Duration(seconds: 60);
}

class BOBBING_SCALE {
  static const NONE = 0.0;
  static const MILD = 0.99;
  static const MEDIUM = 0.95;
  static const AGGRESSIVE = 0.9;
}

// Input

const MAX_POINTER_CLICK_DURATION = const Duration(milliseconds: 500);
const MIN_DRAG_DISTANCE = 20.0;
