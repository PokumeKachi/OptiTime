import 'package:flutter/material.dart';

const String TITLE = 'Todo';
const SEED_COLOR = Color.fromARGB(255, 255, 125, 200);

final ColorScheme COLOR_SCHEME = ColorScheme.fromSeed(
  seedColor: SEED_COLOR,
);

final ColorScheme COLOR_SCHEME_DARK = ColorScheme.fromSeed(
  seedColor: SEED_COLOR,
  brightness: Brightness.dark,
);
