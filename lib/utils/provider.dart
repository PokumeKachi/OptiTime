import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';

import 'data_types.dart';

class StoredProvider with ChangeNotifier {
  late final GetStorage _storage;

  late String _appThemeMode;
  late final List<TaskItem> _taskItems;
  late int _uuidCounter;

  void _save(String key, dynamic value) {
    _storage.write(key, value);
    notifyListeners();
  }

  StoredProvider() {
    _storage = GetStorage();
    _appThemeMode = _storage.read('themeMode') ?? 'System';
    _taskItems = List.from(
      _storage.read('items') ?? [],
    ).map((e) => TaskItem.fromMap(Map<String, dynamic>.from(e))).toList();
    _uuidCounter = _storage.read('uuidCounter') ?? -2147483648;
  }

  String get appThemeMode => _appThemeMode;
  set appThemeMode(String value) {
    if (_appThemeMode != value) {
      _appThemeMode = value;
      _save('themeMode', value);
    }
  }

  List<TaskItem> get taskItems => List.unmodifiable(_taskItems);
  void addTaskItem(TaskItem taskItem) {
    _taskItems.add(taskItem);
    _saveTaskItems();
  }

  void removeTaskItem(TaskItem taskItem) {
    if (_taskItems.remove(taskItem)) _saveTaskItems();
  }

  void addTaskToGroup(SingleTask task, GroupTask group) {
    group.tasks.add(task);
    _saveTaskItems();
  }

  void reorderItems(int oldIndex, int newIndex) {
    final taskItem = _taskItems.removeAt(oldIndex);
    _taskItems.insert(newIndex, taskItem);
    _saveTaskItems();
  }

  void _saveTaskItems() =>
      _save('items', _taskItems.map((e) => e.toMap()).toList());

  int issueNewUUID() {
    final id = _uuidCounter;
    _uuidCounter += 1;
    _save('uuidCounter', _uuidCounter);
    return id;
  }
}

// class ThemeModeProvider with ChangeNotifier {
//   final GetStorage _storage;
//   late String _themeMode;
//
//   ThemeModeProvider(this._storage)
//     : _themeMode = _storage.read('themeMode') ?? 'System';
//
//   String get themeMode => _themeMode;
//
//   void changeThemeMode(String? newMode) {
//     if (newMode == null || newMode == _themeMode) return;
//     _themeMode = newMode;
//     _storage.write('themeMode', newMode);
//     notifyListeners();
//   }
// }

// class ItemProvider with ChangeNotifier {
//   final GetStorage _storage;
//   final List<TaskItem> _items;
//
//   ItemProvider(this._storage)
//     : _items = List.from(
//         _storage.read('items') ?? [],
//       ).map((e) => TaskItem.fromMap(Map<String, dynamic>.from(e))).toList();
//
//   List<TaskItem> get items => List.unmodifiable(_items);
//
//   void addItem(TaskItem item) {
//     _items.add(item);
//     _save();
//   }
//
//   void removeItem(TaskItem item) {
//     if (_items.remove(item)) _save();
//   }
//
//   void addTaskToGroup(SingleTask task, GroupTask group) {
//     group.tasks.add(task);
//     _save();
//   }
//
//   void reorder(int oldIndex, int newIndex) {
//     final item = _items.removeAt(oldIndex);
//     _items.insert(newIndex, item);
//     _save();
//   }
//
//   void _save() {
//     _storage.write(
//       'items',
//       _items.map((e) {
//         return e.toMap();
//       }).toList(),
//     );
//     notifyListeners();
//   }
// }

// class UuidProvider with ChangeNotifier {
//   final GetStorage _storage;
//   late int _uuidCounter;
//
//   UuidProvider(this._storage)
//     : _uuidCounter = _storage.read('uuidCounter') ?? -2147483648;
//
//   int getUUID() {
//     final id = _uuidCounter;
//     _uuidCounter += 1;
//     _storage.write('uuidCounter', _uuidCounter);
//     notifyListeners();
//     return id;
//   }
// }

class CachedProvider extends ChangeNotifier {
  int _overlay = 0;
  int _dialog = 0;

  int get overlayIndex => _overlay;
  set overlayIndex(int value) {
    if (_overlay != value) {
      _overlay = value;
      notifyListeners();
    }
  }

  int get dialogIndex => _dialog;
  set dialogIndex(int value) {
    if (_dialog != value) {
      _dialog = value;
      notifyListeners();
    }
  }
}
