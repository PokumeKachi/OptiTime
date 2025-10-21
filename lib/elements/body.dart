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

    return OrientationBuilder(
      builder: (context, orientation) {
        final size = MediaQuery.of(context).size;
        final height = size.height;
        final width = size.width;
        final portrait = orientation == Orientation.portrait;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: portrait ? height * Config.NAV_BAR_RATIO : 0,
              right: !portrait ? width * Config.NAV_BAR_RATIO : 0,
            ),
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                final task = tasks[i];
                return ListTile(
                  title: Text('${task.title} $i'),
                  subtitle: Text('${task.description}'),
                  trailing: Icon(
                    task.trashed
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

