import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;
import 'group.dart' as Group;
import 'task.dart' as Task;

class Class extends StatelessWidget {
  const Class({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('scroll view rebuild');

    final taskProvider = context.watch<TaskProvider>();
    final groups = taskProvider.groups;
    final tasks = taskProvider.tasks;

    return ListView.separated(
physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: Config.MARGIN_PADDING.NARROW,
      itemCount: groups.length + tasks.length,
      itemBuilder: (context, i) {
        if (i < groups.length) {
          final group = groups[i];
          return Group.Class(group: group);
        } else {
          final task = tasks[i - groups.length];
          return Task.Class(task: task);
        }
      },

      separatorBuilder: (context, i) =>
          SizedBox(height: Config.ITEM_PADDING.NARROW),
    );
  }
}
