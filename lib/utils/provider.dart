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

class TaskProvider with ChangeNotifier {
  final GetStorage _storage;
  final List<Task> _tasks;
  final List<TaskGroup> _groups;

  TaskProvider(this._storage)
    : _tasks = List.from(
        _storage.read('tasks') ?? [],
      ).map((e) => Task.fromMap(Map<String, dynamic>.from(e))).toList(),
      _groups = List.from(
        _storage.read('groups') ?? [],
      ).map((e) => TaskGroup.fromMap(Map<String, dynamic>.from(e))).toList();

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<TaskGroup> get groups => List.unmodifiable(_groups);

  void addTask(Task task) {
    _tasks.add(task);
    _save();
  }

  void addGroup(TaskGroup group) {
    _groups.add(group);
    _save();
  }

  void removeTask(Task task) {
    if (_tasks.remove(task)) _save();
  }

  void removeGroup(TaskGroup group) {
    if (_groups.remove(group)) _save();
  }

  void _save() {
    _storage.write('tasks', _tasks.map((e) => e.toMap()).toList());
    _storage.write('groups', _groups.map((e) => e.toMap()).toList());
    notifyListeners();
  }
}

class OverlayIndexProvider extends ValueNotifier<int> {
  OverlayIndexProvider() : super(0);
}

class DialogIndexProvider extends ValueNotifier<int> {
  DialogIndexProvider() : super(0);
}
