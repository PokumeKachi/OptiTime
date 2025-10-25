import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';

import 'task.dart';

class ThemeModeProvider with ChangeNotifier {
  final GetStorage _storage;
  late String _themeMode;

  ThemeModeProvider(this._storage)
    : _themeMode = _storage.read('themeMode') ?? 'System';

  String get themeMode => _themeMode;

  void changeThemeMode(String? newMode) {
    if (newMode == null || newMode == _themeMode) return;
    _themeMode = newMode;
    _storage.write('themeMode', newMode);
    notifyListeners();
  }
}

class TaskListProvider with ChangeNotifier {
  final GetStorage _storage;
  final List<StorageItem> _items;

  // TaskListProvider(this._storage)
  //   : _items = List<Map<String, dynamic>>.from(
  //       _storage.read('tasks') ?? const <Map<String, dynamic>>[],
  //     ).map(Task.fromMap).toList();
  TaskListProvider(this._storage)
      : _items = ((_storage.read('tasks') ?? <Map<String, dynamic>>[]) as List)
          .map((e) => StorageItem.fromMap(Map<String, dynamic>.from(e)))
          .toList();

  // List<Task> get tasks => List.unmodifiable(_items);

  List<StorageItem> get items => List.unmodifiable(_items);

  // void createTask(Task task) {
  //   _items.add(task);
  //   _save();
  // }
  //
  // void removeTask(Task task) {
  //   if (_items.remove(task)) _save();
  // }

  void addItem(StorageItem item) {
    _items.add(item);
    _save();
  }

  void removeItem(StorageItem item) {
    if (_items.remove(item)) _save();
  }

  void _save() {
    _storage.write('tasks', _items.map((item) => item.toMap()).toList());
    notifyListeners();
  }
}


class OverlayIndexProvider extends ValueNotifier<int> {
  OverlayIndexProvider() : super(0);
}

class DialogIndexProvider extends ValueNotifier<int> {
  DialogIndexProvider() : super(0);
}
