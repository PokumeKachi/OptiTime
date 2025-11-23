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
  Offset? mouseOrigin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final itemProvider = context.watch<ItemProvider>();
    final items = itemProvider.items;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1,
      ),
      physics: Config.SCROLL_PHYSICS,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        late final itemWidget;

        final itemWidgetFactory = (childWidget) {
          return childWidget;
        };

        final singleTaskWidgetFactory = (SingleTask taskInfo) {
          return itemWidgetFactory(Text(taskInfo.name));
        };

        final groupTaskWidgetFactory = (GroupTask groupInfo) {
          return itemWidgetFactory(
            ListView.builder(
              physics: Config.SCROLL_PHYSICS,
              itemCount: groupInfo.tasks.length,
              itemBuilder: (context, index) {
                return singleTaskWidgetFactory(groupInfo.tasks[index]);
              },
            ),
          );
        };

        if (item is SingleTask) {
          itemWidget = singleTaskWidgetFactory(item);
        } else if (item is GroupTask) {
          itemWidget = groupTaskWidgetFactory(item);
        }

        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: item is SingleTask ? null : colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: itemWidget,
          // child: Text(item.name),
        );
      },
    );

    //     return AnimatedReorderableGridView(
    //       items: items,
    //       itemBuilder: (context, index) {
    //         final item = items[index];
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
