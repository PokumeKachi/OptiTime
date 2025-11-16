import 'package:flutter/material.dart';

abstract class TaskItem {
  String get id;
}

class SingleTask extends TaskItem {
  final String _id;
  String name;
  String description;
  DateTime? deadline;
  Duration? duration;
  bool trashed;

  SingleTask({
    required this._id,
    this.name = '',
    this.description = '',
    this.deadline,
    this.duration,
    this.trashed = false,
  });

  Map<String, dynamic> toMap() => {
    'id': _id,
    'title': name,
    'description': description,
    'deadline': deadline?.toIso8601String(),
    'duration': duration?.inSeconds,
    'trashed': trashed,
  };

  factory SingleTask.fromMap(Map<String, dynamic> map) {
    return SingleTask(
      _id: map['id'] as String,
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

  @override
  String get id => _id;
}

class GroupTask extends TaskItem {
  final String _id;
  final String name;
  final List<SingleTask> tasks;

  GroupTask({required this._id, required this.name, required this.tasks});

  Map<String, dynamic> toMap() => {
    'id': _id,
    'name': name,
    'tasks': tasks.map((t) => t.toMap()).toList(),
  };

  factory GroupTask.fromMap(Map<String, dynamic> map) => GroupTask(
    _id: map['id'] as String,
    name: map['name'],
    tasks: (map['tasks'] as List)
        .map((e) => SingleTask.fromMap(Map<String, dynamic>.from(e)))
        .toList(),
  );

  @override
  String get id => _id;
}
