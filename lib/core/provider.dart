import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';

import 'task.dart';

class ThemeModeProvider with ChangeNotifier {
  final GetStorage _storage;
  late String _themeMode;

  String get themeMode => _themeMode;

  ThemeModeProvider(this._storage) {
    _themeMode = _storage.read('themeMode') ?? 'System';
  }

  set themeMode(String themeData) {
    _themeMode = themeData;
    _storage.write('themeMode', themeData);
    notifyListeners();
  }

  void changeThemeMode(String newThemeMode) {
    themeMode = newThemeMode;
  }
}

class TaskListProvider with ChangeNotifier {
  final GetStorage _storage;
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskListProvider(this._storage) {
    final data = _storage.read('tasks') ?? [];
    _tasks = List<Map<String, dynamic>>.from(data)
        .map((e) => Task.fromMap(e))
        .toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _save();
  }

  // void toggleDone(String id) {
  //   final t = _tasks.firstWhere((e) => e.id == id);
  //   t.done = !t.done;
  //   _save();
  // }

  void _save() {
    _storage.write('tasks', _tasks.map((item) => item.toMap()).toList());
    notifyListeners();
  }
}
