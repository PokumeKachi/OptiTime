import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';

class ThemeModeProvider with ChangeNotifier {
  String _themeMode = GetStorage().read('themeMode') ?? 'System';

  String get themeMode => _themeMode;

  set themeMode(String themeData) {
    _themeMode = themeData;
    notifyListeners();
  }

  void changeThemeMode(String newThemeMode) {
    themeMode = newThemeMode;
  }
}
