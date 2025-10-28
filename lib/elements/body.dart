import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/task.dart';

import 'package:todo/utils/config.dart' as Config;

class Class extends StatelessWidget {
  const Class({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('body rebuild');

    final groups = context.watch<TaskProvider>().groups;
    final tasks = context.watch<TaskProvider>().tasks;

    return OrientationBuilder(
      builder: (context, orientation) {
        final colorScheme = Theme.of(context).colorScheme;
        final size = MediaQuery.of(context).size;
        final height = size.height;
        final width = size.width;
        final portrait = height > width;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: portrait ? height * Config.NAV_BAR_RATIO : 0,
              right: !portrait ? width * Config.NAV_BAR_RATIO : 0,
            ),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) =>
                        ListTile(title: Text('${groups[i].name} $i')),
                    childCount: groups.length,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => ListTile(
                      title: Text('${tasks[i].name} $i'),
                      subtitle: Text('${tasks[i].description}'),
                      trailing: Icon(
                        tasks[i].trashed
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                      ),
                    ),
                    childCount: tasks.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
