import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';

import 'data_type.dart';

class ItemProvider with ChangeNotifier {
  late final GetStorage _storage;

  late final List<TaskItem> _list;

  ItemProvider() {
    _storage = GetStorage();
    _list = List.from(
      _storage.read('items') ?? [],
    ).map((e) => TaskItem.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  List<TaskItem> get list => List.unmodifiable(_list);
  void add(TaskItem item) {
    _list.add(item);
    _save();
  }

  void remove(TaskItem item) {
    if (_list.remove(item)) _save();
  }

  void addToGroup(SingleTask task, GroupTask group) {
    group.tasks.add(task);
    _save();
  }

  void reorder(int oldIndex, int newIndex) {
    final item = _list.removeAt(oldIndex);
    _list.insert(newIndex, item);
    _save();
  }

  void _save() {
    _storage.write('items', _list.map((e) => e.toMap()).toList());
    notifyListeners();
  }
}

class StoredProvider with ChangeNotifier {
  late final GetStorage _storage;

  late String _appThemeMode;
  late int _uuidCounter;

  void _save(String key, dynamic value) {
    _storage.write(key, value);
    notifyListeners();
  }

  StoredProvider() {
    _storage = GetStorage();
    _appThemeMode = _storage.read('themeMode') ?? 'System';
    _uuidCounter = _storage.read('uuidCounter') ?? -2147483648;
  }

  String get appThemeMode => _appThemeMode;
  set appThemeMode(String value) {
    if (_appThemeMode != value) {
      _appThemeMode = value;
      _save('themeMode', value);
    }
  }

  int issueNewUUID() {
    final id = _uuidCounter;
    _uuidCounter += 1;
    _save('uuidCounter', _uuidCounter);
    return id;
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

  bool _pointerDown = false;
  bool get pointerDown => _pointerDown;
  set pointerDown(bool value) {
    if (_pointerDown == value) return;
    _pointerDown = value;
    notifyListeners();
  }

  bool clickEvent = false;
  void fireClickEvent() {
    clickEvent = !clickEvent;    
    notifyListeners();
  }

  int? _selectedUUID;
  int? get selectedUUID => _selectedUUID;
  set selectedUUID(int? value) {
    if (_selectedUUID == value) return;
    _selectedUUID = value;
    // notifyListeners();
  }

  bool _pointerDragging = false;
  bool get pointerDragging => _pointerDragging;
  set pointerDragging(bool value) {
    if (_pointerDragging == value) return;
    _pointerDragging = value;
    notifyListeners();
  }

  Offset? _pointerDownOrigin = Offset.zero;
  Offset? get pointerDownOrigin => _pointerDownOrigin;
  set pointerDownOrigin(Offset? value) {
    if (_pointerDownOrigin == value) return;
    _pointerDownOrigin = value;
    notifyListeners();
  }

  Offset _pointerPosition = Offset.zero;
  Offset get pointerPosition => _pointerPosition;
  set pointerPosition(Offset value) {
    if (_pointerPosition == value) return;
    _pointerPosition = value;
    notifyListeners();
  }

  double _mainBodyScrollOffset = 0.0;
  double get mainBodyScrollOffset => _mainBodyScrollOffset;
  set mainBodyScrollOffset(double value) {
    if (_mainBodyScrollOffset != value) {
      _mainBodyScrollOffset = value;
      notifyListeners();
    }
  }
}
