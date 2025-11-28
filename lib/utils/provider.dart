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

  int? _draggedObjectIndex;
  int? get draggedObjectIndex => _draggedObjectIndex;
  set draggedObjectIndex(int? value) {
    if (_draggedObjectIndex == value) return;
    _draggedObjectIndex = value;
    notifyListeners();
  }

  Offset? _draggedObjectOrigin;
  Offset? get draggedObjectOrigin => _draggedObjectOrigin;
  set draggedObjectOrigin(Offset? value) {
    if (_draggedObjectOrigin == value) return;
    _draggedObjectOrigin = value;
    notifyListeners();
  }

  OverlayEntry? _draggedObject;
  OverlayEntry? get draggedObject => _draggedObject;
  set draggedObject(OverlayEntry? value) {
    if (_draggedObject == value) return;
    _draggedObject = value;
    notifyListeners();
  }

  bool _draggedObjectShouldBeVisible = false;
  bool get draggedObjectShouldBeVisible => _draggedObjectShouldBeVisible;
  set draggedObjectShouldBeVisible(bool value) {
    if (_draggedObjectShouldBeVisible == value) return;
    _draggedObjectShouldBeVisible = value;
    notifyListeners();
  }

  bool _draggedObjectIsVisible = false;
  bool get draggedObjectIsVisible => _draggedObjectIsVisible;
  set draggedObjectIsVisible(bool value) {
    if (_draggedObjectIsVisible == value) return;
    _draggedObjectIsVisible = value;
    notifyListeners();
  }
}
