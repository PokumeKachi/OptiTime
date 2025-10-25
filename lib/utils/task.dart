import 'package:flutter/material.dart';

abstract class StorageItem {
  StorageItem();

  Map<String, dynamic> toMap();
  factory StorageItem.fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case 0:
        return Task.fromMap(map);
      case 1:
        return TaskGroup.fromMap(map);
      default:
        throw Exception('Unknown type');
    }
  }
}

class Task extends StorageItem {
  String title;
  String description;
  DateTime? deadline;
  Duration? duration;
  bool trashed;

  Task({
    this.title = '',
    this.description = '',
    this.deadline,
    this.duration,
    this.trashed = false,
  });

  @override
  Map<String, dynamic> toMap() => {'type': 0, 'title': title};

  factory Task.fromMap(Map<String, dynamic> map) {
    final title = map['title'] as String? ?? '';
    final description = map['description'] as String? ?? '';
    final deadlineStr = map['deadline'] as String?;
    final durationSec = map['duration'] as int?;
    final trashed = map['trashed'] as bool? ?? false;

    return Task(
      title: title,
      description: description,
      deadline: deadlineStr != null ? DateTime.parse(deadlineStr) : null,
      duration: durationSec != null ? Duration(seconds: durationSec) : null,
      trashed: trashed,
    );
  }
}

class TaskGroup extends StorageItem {
  final String name;
  final List<Task> tasks;

  TaskGroup({required this.name, required this.tasks});

  @override
  Map<String, dynamic> toMap() => {
    'type': 1,
    'name': name,
    'tasks': tasks.map((t) => t.toMap()).toList(),
  };

  factory TaskGroup.fromMap(Map<String, dynamic> map) => TaskGroup(
    name: map['name'],
    tasks: (map['tasks'] as List)
        .map((e) => Task.fromMap(Map<String, dynamic>.from(e)))
        .toList(),
  );
}
