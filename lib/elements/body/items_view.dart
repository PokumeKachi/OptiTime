import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';

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

  void updateScrollOffset() {
    context.read<CachedProvider>().mainBodyScrollOffset = _controller.offset;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(updateScrollOffset);
  }

  @override
  void dispose() {
    _controller.removeListener(updateScrollOffset);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final SIZE = MediaQuery.of(context).size;
    final HEIGHT = SIZE.height;
    final WIDTH = SIZE.width;
    final PORTRAIT = HEIGHT > WIDTH;

    late final BODY_WIDTH;
    late final BODY_HEIGHT;
    late final NAVBAR_WIDTH;
    late final NAVBAR_HEIGHT;

    if (PORTRAIT) {
      BODY_WIDTH = NAVBAR_WIDTH = WIDTH;
      BODY_HEIGHT = HEIGHT * (1 - Config.NAV_BAR_RATIO);
      NAVBAR_HEIGHT = HEIGHT * Config.NAV_BAR_RATIO;
    } else {
      BODY_HEIGHT = NAVBAR_HEIGHT = HEIGHT;
      BODY_WIDTH = WIDTH * (1 - Config.NAV_BAR_RATIO);
      NAVBAR_WIDTH = WIDTH * Config.NAV_BAR_RATIO;
    }

    final items = context.watch<ItemProvider>().list;
    final isDraggingItem = context.select<CachedProvider, bool>(
      (p) {
        if (p.selectedUUID != null) {
          return true;
        }

        return false;
      }
    );

    return AnimatedGridView(
      padding: EdgeInsets.all(Config.MAIN_BODY_MARGIN),
      sliverGridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: Config.TASK_ITEM_MAX_WIDTH,
        crossAxisSpacing: Config.MAIN_BODY_MARGIN,
        mainAxisSpacing: Config.MAIN_BODY_MARGIN,
        childAspectRatio: 1,
      ),
      controller: _controller,
      physics: isDraggingItem ? const NeverScrollableScrollPhysics() : Config.SCROLL_PHYSICS,
      // itemCount: items.length,
      items: items,
      enterTransition: [FadeIn(), ScaleIn()],
      exitTransition: [SlideInDown()],
      isSameItem: (a, b) => a.uuid == b.uuid,
      itemBuilder: (context, index) {
        final ROW_COUNT = BODY_WIDTH ~/ Config.TASK_ITEM_MAX_WIDTH + 1;
        final CELL_WIDTH = BODY_WIDTH / ROW_COUNT;
        final CELL_HEIGHT = CELL_WIDTH;

        final item = items[index];

        return Selector<CachedProvider, bool>(
          key: ValueKey(item.uuid),
          selector: (_, p) => p.pointerDragging && p.selectedUUID == item.uuid,
          builder: (_, isDragged, child) {
            if (isDragged) {
              return SizedBox.expand();
            }
            return Item.Class(index: index);
          },
        );
      },
    );
    // return GridView.builder(
    //   padding: EdgeInsets.all(Config.MAIN_BODY_MARGIN),
    //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //     maxCrossAxisExtent: Config.TASK_ITEM_MAX_WIDTH,
    //     crossAxisSpacing: Config.MAIN_BODY_MARGIN,
    //     mainAxisSpacing: Config.MAIN_BODY_MARGIN,
    //     childAspectRatio: 1,
    //   ),
    //   controller: _controller,
    //   physics: Config.SCROLL_PHYSICS,
    //   itemCount: items.length,
    //   itemBuilder: (context, index) {
    //     final ROW_COUNT = BODY_WIDTH ~/ Config.TASK_ITEM_MAX_WIDTH + 1;
    //     final CELL_WIDTH = BODY_WIDTH / ROW_COUNT;
    //     final CELL_HEIGHT = CELL_WIDTH;
    //
    //     final item = items[index];
    //
    //     late final itemWidget;
    //
    //     final itemWidgetFactory = (childWidget) {
    //       return childWidget;
    //     };
    //
    //     final singleTaskWidgetFactory = (SingleTask taskInfo) {
    //       return itemWidgetFactory(Text(taskInfo.name));
    //     };
    //
    //     final groupTaskWidgetFactory = (GroupTask groupInfo) {
    //       return itemWidgetFactory(
    //         ListView.builder(
    //           physics: Config.SCROLL_PHYSICS,
    //           itemCount: groupInfo.tasks.length,
    //           itemBuilder: (context, index) {
    //             return singleTaskWidgetFactory(groupInfo.tasks[index]);
    //           },
    //         ),
    //       );
    //     };
    //
    //     if (item is SingleTask) {
    //       itemWidget = singleTaskWidgetFactory(item);
    //     } else if (item is GroupTask) {
    //       itemWidget = groupTaskWidgetFactory(item);
    //     }
    //
    //     return Selector<CachedProvider, bool>(
    //       selector: (_, p) {
    //         if (!p.pointerDown) {
    //           return false;
    //         }
    //         if (p.selectedUUID != null) {
    //           return p.selectedUUID == item.uuid;
    //         }
    //
    //         // if (Algorithms.aabbCollision(
    //         //       p.pointerPosition,
    //         //       Offset(
    //         //         (index % ROW_COUNT).toDouble() * CELL_WIDTH,
    //         //         (index ~/ ROW_COUNT).toDouble() * CELL_HEIGHT,
    //         //       ),
    //         //       Offset(CELL_WIDTH, CELL_HEIGHT),
    //         //     )) {
    //         //   p.selectedUUID = item.uuid;
    //         //   return true;
    //         // } else
    //         return false;
    //       },
    //       builder: (_, isDragged, child) {
    //         return Container(
    //           padding: EdgeInsets.all(8),
    //           decoration: BoxDecoration(
    //             color: item is SingleTask
    //                 ? colorScheme.secondaryContainer
    //                 : colorScheme.tertiaryContainer,
    //             borderRadius: BorderRadius.circular(
    //               isDragged ? Config.CORNER.ROUNDEST : Config.CORNER.NONE,
    //             ),
    //           ),
    //           // child: itemWidget,
    //           child: Text(
    //             index.toString() +
    //                 ' and ' +
    //                 ROW_COUNT.toString() +
    //                 ' and ' +
    //                 Offset(
    //                   (index % ROW_COUNT).toDouble() * CELL_WIDTH,
    //                   (index ~/ ROW_COUNT).toDouble() * CELL_HEIGHT,
    //                 ).toString() +
    //                 ' and ' +
    //                 Offset(CELL_WIDTH, CELL_HEIGHT).toString(),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );

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
