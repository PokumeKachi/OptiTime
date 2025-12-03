import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data_type.dart';

class ItemProvider with ChangeNotifier {
  late final GetStorage _storage;

  late final List<TaskItem> _list;
  late int _uuidCounter;

  ItemProvider() {
    _storage = GetStorage();
    _list = List.from(
      _storage.read('items') ?? [],
    ).map((e) => TaskItem.fromMap(Map<String, dynamic>.from(e))).toList();
    _uuidCounter = _storage.read('uuidCounter') ?? -2147483648;

    _rebuildIndexMap();
  }
  final Map<int, int> _indexOfUuid = {};

  void _rebuildIndexMap() {
    _indexOfUuid.clear();
    for (var i = 0; i < _list.length; i++) {
      _indexOfUuid[_list[i].uuid] = i;
    }
  }

  int getIndexOfUuid(int uuid) {
    return _indexOfUuid[uuid] ?? -1;
  }

  List<TaskItem> get list => List.unmodifiable(_list);
  void add(TaskItem item) {
    _list.add(item);
    _rebuildIndexMap();
    _save();
  }

  void remove(TaskItem item) {
    if (_list.remove(item)) {
      _rebuildIndexMap();
      _save();
    }
  }

  void removeAt(int itemIndex) {
    if (itemIndex >= 0 && itemIndex < _list.length) {
      _list.removeAt(itemIndex);
      _rebuildIndexMap();
      _save();
    }
  }

  void addToGroup(SingleTask task, GroupTask group) {
    group.tasks.add(task);
    _save();
  }

  void reorder(int oldIndex, int newIndex) {
    final item = _list.removeAt(oldIndex);
    _list.insert(newIndex, item);
    _rebuildIndexMap();
    _save();
  }

  void _save() {
    _storage.write('items', _list.map((e) => e.toMap()).toList());
    notifyListeners();
  }

  int issueNewUUID() {
    final id = _uuidCounter;
    _uuidCounter += 1;
    _storage.write('uuidCounter', _uuidCounter);
    return id;
  }

  void listenToSupabase(String userId) {
    Supabase.instance.client
        .channel('user_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'users',
          callback: (payload) {
            final updatedUser = Map<String, dynamic>.from(
              payload.newRecord ?? {},
            );
            print(updatedUser['data']);
          },
        )
        .subscribe();
  }
}

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
      _save('themeMode', value.toString());
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
}
