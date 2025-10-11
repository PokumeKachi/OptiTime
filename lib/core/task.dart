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
        'deadline': deadline?.toIso8601String(),
        'duration': duration?.inSeconds,
        'trashed': trashed,
      };

  static Task fromMap(Map<String, dynamic> map) => Task(
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        deadline: map['deadline'] != null
            ? DateTime.parse(map['deadline'])
            : null,
        duration: map['duration'] != null
            ? Duration(seconds: map['duration'])
            : null,
        trashed: map['trashed'] ?? false,
      );
}
