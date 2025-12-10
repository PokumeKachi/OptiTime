export 'providers/synced.dart';

import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data_type.dart';

class StoredProvider with ChangeNotifier {
  late final GetStorage _storage;
  late ThemeMode _appThemeMode;
  late Locale _locale;

  void _save(String key, dynamic value) {
    _storage.write(key, value);
    notifyListeners();
  }

  StoredProvider() {
    _storage = GetStorage();
    _appThemeMode = ThemeMode.values.firstWhere(
      (m) => m.name == _storage.read('themeMode'),
      orElse: () => ThemeMode.system,
    );
    _locale = Locale(_storage.read('locale') ?? 'en');
  }

  ThemeMode get appThemeMode => _appThemeMode;
  set appThemeMode(ThemeMode value) {
    if (_appThemeMode != value) {
      _appThemeMode = value;
      _save('themeMode', value.name.toString());
    }
  }

  Locale get locale => _locale;
  set locale(Locale value) {
    if (_locale != value) {
      _locale = value;
      _save('locale', value.toString());
    }
  }
}

class CachedProvider extends ChangeNotifier {
  int _overlay = 0;
  int get overlayIndex => _overlay;
  set overlayIndex(int value) {
    if (_overlay == value) return;
    _overlay = value;
    notifyListeners();
  }

  int _dialog = 0;
  int get dialogIndex => _dialog;
  set dialogIndex(int value) {
    if (_dialog == value) return;
    _dialog = value;
    notifyListeners();
  }

  int? _selectedUUID;
  int? get selectedUUID => _selectedUUID;
  set selectedUUID(int? value) {
    if (_selectedUUID == value) return;
    _selectedUUID = value;
    notifyListeners();
  }

  String? _userId;
  String? get userId => _userId;
  set userId(String? value) {
    if (_userId == value) return;
    _userId = value;
    notifyListeners();
  }

  Duration? _focusDuration;
  Duration? get focusDuration => _focusDuration;
  set focusDuration(Duration? value) {
    if (_focusDuration == value) return;
    _focusDuration = value;
    notifyListeners();
  }

  void endFocusSession() {
    Future.microtask(() {
      focusDuration = null;
      overlayIndex = 0;
      print('done already?');
      notifyListeners();
    });
  }

  CachedProvider({String? userId}) {
    _userId = userId ?? Supabase.instance.client.auth.currentUser?.id;

    print('rad this');
    print(Supabase.instance.client.auth.currentUser?.id);
  }
}
