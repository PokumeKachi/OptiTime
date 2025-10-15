import 'package:flutter/material.dart';

// Core properties

const String TITLE = 'Todo';

// Color scheming

const SEED_COLOR = Color.fromRGBO(225, 215, 125, 1);

final ColorScheme COLOR_SCHEME = ColorScheme.fromSeed(
  seedColor: SEED_COLOR,
);

final ColorScheme COLOR_SCHEME_DARK = ColorScheme.fromSeed(
  seedColor: SEED_COLOR,
  brightness: Brightness.dark,
);

// Element sizing

const NAV_BAR_HEIGHT_RATIO = 0.07;

const FONT_SIZE = {
  "SMALL": 16.0,
  "MEDIUM": 24.0,
  "BIG": 32.0,
};

// Element positioning

const MARGIN_PADDING = EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0);
const ITEM_PADDING = 8.0;

// Element decorating

const MIN_CORNER = 2.0;
const MAX_CORNER = 16.0;

const ANIMATION_DURATION = 250;
