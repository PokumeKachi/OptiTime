import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/data_type.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;
import 'item.dart' as Item;
import 'group.dart' as Group;
import 'task.dart' as Task;

class Class extends StatefulWidget {
  const Class({super.key});
  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  late final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final items = context.watch<ItemProvider>().list;

    return GridView.builder(
      padding: EdgeInsets.all(Config.MAIN_BODY_MARGIN),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: Config.TASK_ITEM_MAX_WIDTH,
        crossAxisSpacing: Config.MAIN_BODY_MARGIN,
        mainAxisSpacing: Config.MAIN_BODY_MARGIN,
        childAspectRatio: 1,
      ),
      controller: _controller,
      physics: Config.SCROLL_PHYSICS,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Item.Class(uuid: item.uuid);
      },
    );
  }
}
