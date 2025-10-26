import 'package:flutter/material.dart';

class Task {
  String name;
  String description;
  DateTime? deadline;
  Duration? duration;
  bool trashed;

  Task({
    this.name = '',
    this.description = '',
    this.deadline,
    this.duration,
    this.trashed = false,
  });

  Map<String, dynamic> toMap() => {
    'title': name,
    'description': description,
    'deadline': deadline?.toIso8601String(),
    'duration': duration?.inSeconds,
    'trashed': trashed,
  };

  factory Task.fromMap(Map<String, dynamic> map) {
    final title = map['title'] as String? ?? '';
    final description = map['description'] as String? ?? '';
    final deadlineStr = map['deadline'] as String?;
    final durationSec = map['duration'] as int?;
    final trashed = map['trashed'] as bool? ?? false;

    return Task(
      name: title,
      description: description,
      deadline: deadlineStr != null ? DateTime.parse(deadlineStr) : null,
      duration: durationSec != null ? Duration(seconds: durationSec) : null,
      trashed: trashed,
    );
  }
}

class TaskGroup {
  final String name;
  final List<Task> tasks;

  TaskGroup({required this.name, required this.tasks});

  Map<String, dynamic> toMap() => {
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
