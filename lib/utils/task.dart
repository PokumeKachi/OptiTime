import 'package:flutter/material.dart';

class Task {
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

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    if (deadline != null) 'deadline': deadline!.toIso8601String(),
    if (duration != null) 'duration': duration!.inSeconds,
    'trashed': trashed,
  };

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
