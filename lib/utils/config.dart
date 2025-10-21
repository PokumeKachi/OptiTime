import 'package:flutter/material.dart';

// Core properties

const TITLE = 'Todo';
const PRELOAD_DURATION = Duration(milliseconds: 200);

// Color scheming

const SEED_COLOR = Color.fromRGBO(225, 215, 125, 1);

final ColorScheme COLOR_SCHEME = ColorScheme.fromSeed(
  seedColor: SEED_COLOR,
);

final ColorScheme COLOR_SCHEME_DARK = ColorScheme.fromSeed(
  seedColor: SEED_COLOR,
  brightness: Brightness.dark,
);

const DIM_OPACITY = 0.3;
const DIM_OPACITY_DARK = 0.5;

// Element sizing

const NAV_BAR_RATIO = 0.08;
// const NAV_BAR_WIDTH_RATIO = 0.05;

class FONT_SIZE {
  static const SMALL = 16.0;
  static const MEDIUM = 24.0;
  static const BIG = 32.0;
}

// Element positioning

const MARGIN_PADDING = EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0);
const ITEM_PADDING = 8.0;

// Element decorating

const MIN_CORNER = 2.0;
const MAX_CORNER = 16.0;

const ANIMATION_DURATION = 250;
