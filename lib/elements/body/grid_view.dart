import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:auto_height_grid_view/auto_height_grid_view.dart';

import 'package:todo/utils/data_type.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;

import 'grid_entry.dart' as Entry;

class Class extends StatefulWidget {
  const Class({super.key});
  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  late final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final items = context.watch<SyncedProvider>().items;

    final SIZE = MediaQuery.of(context).size;
    final HEIGHT = SIZE.height;
    final WIDTH = SIZE.width;
    final PORTRAIT = HEIGHT > WIDTH;

    // return AutoHeightGridView(
    //   crossAxisSpacing: Config.MAIN_BODY_MARGIN,
    //   mainAxisSpacing: Config.MAIN_BODY_MARGIN,
    //   crossAxisCount: WIDTH ~/ Config.TASK_ENTRY_MAX_WIDTH,
    //   padding: EdgeInsets.all(Config.MAIN_BODY_MARGIN),
    //   controller: _controller,
    //   physics: Config.SCROLL_PHYSICS,
    //   itemCount: items.length,
    //   builder: (context, index) {
    //     final item = items[index];
    //
    //     return Entry.Class(uuid: item.uuid);
    //   },
    // );

    // return DynamicHeightGridView(
    //   // padding: EdgeInsets.all(Config.MAIN_BODY_MARGIN),
    //   // maxCrossAxisExtent: Config.TASK_ITEM_MAX_WIDTH,
    //   crossAxisSpacing: Config.MAIN_BODY_MARGIN,
    //   mainAxisSpacing: Config.MAIN_BODY_MARGIN,
    //   crossAxisCount: WIDTH ~/ Config.TASK_ENTRY_MAX_WIDTH,
    //   controller: _controller,
    //   physics: Config.SCROLL_PHYSICS,
    //   itemCount: items.length,
    //   builder: (context, index) {
    //     final item = items[index];
    //
    //     return Entry.Class(uuid: item.uuid);
    //   },
    // );

    return GridView.builder(
      padding: EdgeInsets.all(Config.MAIN_BODY_MARGIN),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: Config.TASK_ENTRY_MAX_WIDTH,
        crossAxisSpacing: Config.MAIN_BODY_MARGIN,
        mainAxisSpacing: Config.MAIN_BODY_MARGIN,
        childAspectRatio: 1,
      ),
      controller: _controller,
      physics: Config.SCROLL_PHYSICS,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Entry.Class(uuid: item.uuid);
      },
    );
  }
}
