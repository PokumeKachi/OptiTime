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

    final items = context.watch<TaskListProvider>().items;

    return OrientationBuilder(
      builder: (context, orientation) {
        final colorScheme = Theme.of(context).colorScheme;
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
            child: Container(
              color: colorScheme.background,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  if (item is Task) {
                    return ListTile(
                      title: Text('${item.title} $i'),
                      subtitle: Text('${item.description}'),
                      trailing: Icon(
                        item.trashed
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                      ),
                    );
                  }
                  ;
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
