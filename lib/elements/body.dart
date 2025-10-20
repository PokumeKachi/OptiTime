import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/task.dart';

import 'package:todo/utils/config.dart' as Config;

class Class extends StatelessWidget {
  const Class({super.key});

  @override
  Widget build(BuildContext context) {
    print('body rebuild');

    final tasks = context.watch<TaskListProvider>().tasks;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).size.height * Config.NAV_BAR_RATIO,
        ),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, i) {
            final task = tasks[i];
            return ListTile(
              title: Text('${task.title} $i'),
              subtitle: Text(task.description ?? ''),
              trailing: Icon(
                task.trashed ? Icons.check_circle : Icons.circle_outlined,
              ),
            );
          },
        ),
      ),
    );
  }
}
