import 'package:flutter/material.dart';

enum ItemType { singleTask, groupTask }

abstract class TaskItem {
  final int uuid;
  final String name;

  const TaskItem({required this.uuid, required this.name});

  Map<String, dynamic> toMap();
  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return map['type'] == ItemType.groupTask.index
        ? GroupTask.fromMap(map)
        : SingleTask.fromMap(map);
  }
}

class SingleTask extends TaskItem {
  final int uuid;
  String name;
  String description;
  DateTime? deadline;
  Duration? duration;
  bool trashed;

  SingleTask({
    required this.uuid,
    this.name = '',
    this.description = '',
    this.deadline,
    this.duration,
    this.trashed = false,
  }) : super(uuid: uuid, name: name);

  Map<String, dynamic> toMap() => {
    'type': ItemType.singleTask.index,
    'id': uuid,
    'title': name,
    'description': description,
    'deadline': deadline?.toIso8601String(),
    'duration': duration?.inSeconds,
    'trashed': trashed,
  };

  factory SingleTask.fromMap(Map<String, dynamic> map) {
    return SingleTask(
      uuid: map['id'],
      name: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      deadline: map['deadline'] != null
          ? DateTime.parse(map['deadline'])
          : null,
      duration: map['duration'] != null
          ? Duration(seconds: map['duration'])
          : null,
      trashed: map['trashed'] as bool? ?? false,
    );
  }
}

class GroupTask extends TaskItem {
  final int uuid;
  final String name;
  final List<SingleTask> tasks;

  GroupTask({required this.uuid, required this.name, required this.tasks}) : super(uuid: uuid, name: name);

  Map<String, dynamic> toMap() => {
    'type': ItemType.groupTask.index,
    'id': uuid,
    'name': name,
    'tasks': tasks.map((t) => t.toMap()).toList(),
  };

  factory GroupTask.fromMap(Map<String, dynamic> map) => GroupTask(
    uuid: map['id'],
    name: map['name'],
    tasks: (map['tasks'] as List)
        .map((e) => SingleTask.fromMap(Map<String, dynamic>.from(e)))
        .toList(),
  );
}
