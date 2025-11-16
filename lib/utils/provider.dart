import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';

import 'data_types.dart';

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

class UuidProvider with ChangeNotifier {
  final GetStorage _storage;
  late int _uuidCounter;

  UuidProvider(this._storage)
    : _uuidCounter = _storage.read('uuidCounter') ?? -2147483648;

  int getUUID() {
    final id = _uuidCounter;
    _uuidCounter += 1;
    _storage.write('uuidCounter', _uuidCounter);
    notifyListeners();
    return id;
  }
}

class ItemProvider with ChangeNotifier {
  final GetStorage _storage;
  // final List<SingleTask> _tasks;
  // final List<GroupTask> _groups;
  final List<TaskItem> _items;

  ItemProvider(this._storage)
    : _items = List.from(
        _storage.read('items') ?? [],
      ).map((e) => TaskItem.fromMap(Map<String, dynamic>.from(e))).toList();

  List<TaskItem> get items => List.unmodifiable(_items);

  void addItem(TaskItem item) {
    _items.add(item);
    _save();
  }

  void removeItem(TaskItem item) {
    if (_items.remove(item)) _save();
  }

  void addTaskToGroup(SingleTask task, GroupTask group) {
    group.tasks.add(task);
    _save();
  }

  void _save() {
    _storage.write(
      'items',
      _items.map((e) {
        return e.toMap();
      }).toList(),
    );
    notifyListeners();
  }

  // TaskProvider(this._storage)
  //   : _tasks = List.from(
  //       _storage.read('tasks') ?? [],
  //     ).map((e) => SingleTask.fromMap(Map<String, dynamic>.from(e))).toList(),
  //     _groups = List.from(
  //       _storage.read('groups') ?? [],
  //     ).map((e) => GroupTask.fromMap(Map<String, dynamic>.from(e))).toList();
  //
  // List<SingleTask> get tasks => List.unmodifiable(_tasks);
  // List<GroupTask> get groups => List.unmodifiable(_groups);
  //
  // void addTask(SingleTask task) {
  //   _tasks.add(task);
  //   _save();
  // }
  //
  // void addTaskToGroup(SingleTask task, GroupTask group) {
  //   group.tasks.add(task);
  //   _save();
  // }
  //
  // void addGroup(GroupTask group) {
  //   _groups.add(group);
  //   _save();
  // }
  //
  // void removeTask(SingleTask task) {
  //   if (_tasks.remove(task)) _save();
  // }
  //
  // void removeGroup(GroupTask group) {
  //   if (_groups.remove(group)) _save();
  // }
  //
  // void _save() {
  //   _storage.write('tasks', _tasks.map((e) => e.toMap()).toList());
  //   _storage.write('groups', _groups.map((e) => e.toMap()).toList());
  //   notifyListeners();
  // }
}

class OverlayIndexProvider extends ValueNotifier<int> {
  OverlayIndexProvider() : super(0);
}

class DialogIndexProvider extends ValueNotifier<int> {
  DialogIndexProvider() : super(0);
}
