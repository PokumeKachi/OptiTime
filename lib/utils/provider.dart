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
  final List<Task> _tasks;

  TaskListProvider(this._storage)
    : _tasks = List<Map<String, dynamic>>.from(
        _storage.read('tasks') ?? const <Map<String, dynamic>>[],
      ).map(Task.fromMap).toList();

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(Task task) {
    _tasks.add(task);
    _save();
  }

  void removeTask(Task task) {
    if (_tasks.remove(task)) _save();
  }

  void _save() {
    _storage.write('tasks', _tasks.map((item) => item.toMap()).toList());
    notifyListeners();
  }
}

class OverlayIndexProvider extends ValueNotifier<int> {
  OverlayIndexProvider([int initial = 0]) : super(initial);

  int get overlayIndex => value;
  set overlayIndex(int newValue) => value = newValue;
}

