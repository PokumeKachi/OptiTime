import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/data_types.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;
import 'group.dart' as Group;
import 'task.dart' as Task;

class Class extends StatefulWidget {
  const Class({super.key});
  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  @override
  Widget build(BuildContext context) {
    final itemProvider = context.watch<ItemProvider>();
    final items = itemProvider.items;

    // return SizedBox.expand();
    //     return AnimatedReorderableGridView(
    //       physics: const BouncingScrollPhysics(
    //         parent: AlwaysScrollableScrollPhysics(),
    //       ),
    //       items: items,
    //       itemBuilder: (context, index) {
    //         final item = items[index];
    //
    // retur GestureDetector(
    //   // onTap: () => select(item),
    //           onTap: () {},
    //   onLongPressStart: (details) {
    //     dragKey.currentState?.startDrag(details.globalPosition);
    //   },
    //   child: LongPressDraggable(
    //     maxSimultaneousDrags: 0,
    //     data: item,
    //     feedback: buildGhost(item),
    //     child: buildItem(item),
    //   ),
    // );
    //         // return SizedBox.expand(
    //         //   key: ValueKey(item.id),
    //         //   child: DragTarget(
    //         //     builder: (BuildContext context, someList, someOtherList) {
    //         //       print(someList);
    //         //       print(someOtherList);
    //         //       return TextButton(
    //         //         onPressed: () {
    //         //           print('yea');
    //         //         },
    //         //         child: Text(item.name),
    //         //       );
    //         //     },
    //         //   ),
    //         // );
    //       },
    //       onReorder: (oldIndex, newIndex) {
    //         itemProvider.reorder(oldIndex, newIndex);
    //       },
    //       sliverGridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: 4,
    //       ),
    //       enterTransition: [FlipInX(), ScaleIn()],
    //       exitTransition: [SlideInLeft()],
    //       insertDuration: const Duration(milliseconds: 300),
    //       removeDuration: const Duration(milliseconds: 300),
    //       dragStartDelay: const Duration(milliseconds: 500),
    //       isSameItem: (a, b) => a.id == b.id,
    //     );
  }
}
