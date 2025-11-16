import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/data_types.dart';

class Class extends StatelessWidget {
  const Class({super.key, required this.task});

  final SingleTask task;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.primary,
      child: Column(
        children: [
          Text('${task.name}', style: TextStyle(color: colorScheme.onSecondary)),
        ],
      ),
      // title: Text('${task.name}'),
      // subtitle: Text(task.description),
      // trailing: Icon(task.trashed ? Icons.check_circle : Icons.circle_outlined),
    );
  }
}
