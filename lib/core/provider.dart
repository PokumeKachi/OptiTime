import 'package:flutter/material.dart';

class ThemeModeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeData) {
    _themeMode = themeData;
    notifyListeners();
  }

  void changeThemeMode(ThemeMode newThemeMode) {
    themeMode = newThemeMode;
  }
}
