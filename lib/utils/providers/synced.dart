import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo/l10n/app_localizations.dart';

import 'package:todo/utils/data_type.dart';

import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/notify.dart' as Notify;

Future<void> _upsertWithToken(Map<String, dynamic> values) async {
  final session = Supabase.instance.client.auth.currentSession;
  final token = session?.accessToken;

  if (token == null) throw Exception('No access token');

  values['last_updated_by'] = token;

  await Supabase.instance.client.from('users').upsert(values);
}

List<TaskItem> _parseItemData(dynamic data) {
  if (data == null) return [];
  return (data as List)
      .map((e) => TaskItem.fromMap(Map<String, dynamic>.from(e)))
      .toList();
}

class SyncedProvider with ChangeNotifier {
  late final GetStorage _storage;
  final Map<int, (int, int?)> _indexOfUuid = {};
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  final GlobalKey<NavigatorState> navigatorKey;

  late List<TaskItem> _items;
  late int _uuidCounter;

  void _rebuildIndexMap() {
    _indexOfUuid.clear();

    for (var parentEntry in _items.asMap().entries) {
      final parentIndex = parentEntry.key;
      final item = parentEntry.value;

      if (item is SingleTask) {
        _indexOfUuid[item.uuid] = (parentIndex, 0);
      } else if (item is GroupTask) {
        for (var childIndex = 0; childIndex < item.tasks.length; childIndex++) {
          final child = item.tasks[childIndex];
          _indexOfUuid[child.uuid] = (parentIndex, childIndex);
        }
        _indexOfUuid[item.uuid] = (parentIndex, null);
      }
    }

    notifyListeners();
  }

  void _saveItems() {
    _storage.write('items', _items.map((e) => e.toMap()).toList());
    notifyListeners();
    _syncItems();
  }

  void _saveUUID() {
    _storage.write('uuidCounter', _uuidCounter);
    _syncUUID();
  }

  void _syncItems() => _upsertWithToken({
    'items': jsonEncode(_items.map((e) => e.toMap()).toList()),
  });

  void _syncUUID() => _upsertWithToken({'uuid_counter': _uuidCounter});

  void _subscribeDatabase() {
    _subscription?.cancel();

    final supabase = Supabase.instance.client;

    _subscription = supabase.from('users').stream(primaryKey: ['id']).listen((
      List<Map<String, dynamic>> data,
    ) {
      if (data.isEmpty ||
          data[0]['items'] == null ||
          data[0]['uuid_counter'] == null ||
          data[0]['last_updated_by'] == null) {
        _syncItems();
        _syncUUID();
        return;
      }

      if (data[0]['last_updated_by'] ==
          supabase.auth.currentSession?.accessToken) {
        return;
      }

      final context = navigatorKey.currentContext;

      if (context != null) {
        final loc = AppLocalizations.of(navigatorKey.currentContext!)!;
        Notify.send(
          context: navigatorKey.currentContext!,
          title: loc.databaseUpdateNotificationTitle,
          subtitle: loc.databaseUpdateNotificationSubtitle,
          accentColor: Colors.green,
          duration: Config.NOTIFICATION.MEDIUM,
        );
      }

      final items = data[0]['items'];
      final uuidCounter = data[0]['uuid_counter'];

      if (items is String) {
        _items = _parseItemData(jsonDecode(items));
      } else {
        _items = _parseItemData(items);
      }

      _uuidCounter = uuidCounter;
      _rebuildIndexMap();
      notifyListeners();
    });
  }

  SyncedProvider(this.navigatorKey) {
    _storage = GetStorage();

    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      final session = event.session;

      if (session != null) {
        _subscribeDatabase();
      } else {
        _subscription?.cancel();
        _subscription = null;
      }
    });

    _items = _parseItemData(_storage.read('items'));
    _uuidCounter = _storage.read('uuidCounter') ?? -2147483648;

    _rebuildIndexMap();
  }

  List<TaskItem> get items => List.unmodifiable(_items);
  void add(TaskItem item) {
    _items.add(item);
    _rebuildIndexMap();
    _saveItems();
  }

  (int, int?) getIndexOfUuid(int uuid) {
    return _indexOfUuid[uuid] ?? (-1, null);
  }

  TaskItem getItemFromUuid(int uuid) {
    (int, int?) index = getIndexOfUuid(uuid);

    final baseItem = _items[index.$1];

    print(index.$1.toString() + ' and ' + index.$2.toString());

    if (baseItem is GroupTask && index.$2 != null) {
      baseItem.tasks[index.$2!];
    }

    return baseItem;
  }

  void remove(int uuid) {
    (int, int?) index = getIndexOfUuid(uuid);

    final baseItem = _items[index.$1];

    if (baseItem is GroupTask && index.$2 != null) {
      baseItem.tasks.removeAt(index.$2!);
      if (baseItem.tasks.isEmpty) {
        _items.removeAt(index.$1);
      }

      _saveItems();
      _rebuildIndexMap();
      return;
    }

    _items.removeAt(index.$1);

    _saveItems();
    _rebuildIndexMap();
  }

  void addToGroup(SingleTask task, GroupTask group) {
    group.tasks.add(task);
    _rebuildIndexMap();
    _saveItems();
  }

  void reorder(int oldIndex, int newIndex) {
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    _rebuildIndexMap();
    _saveItems();
  }

  int issueNewUUID() {
    final id = _uuidCounter;
    _uuidCounter += 1;
    _saveUUID();
    return id;
  }
}
