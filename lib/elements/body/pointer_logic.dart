import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;
import 'package:todo/elements/body/item.dart' as Item;

bool aabbCollision(Offset point, Offset origin, Offset size) {
  return point.dx >= origin.dx &&
      point.dx <= origin.dx + size.dx &&
      point.dy >= origin.dy &&
      point.dy <= origin.dy + size.dy;
}

int getIndexAtCursor(BuildContext context) {
  final cachedProvider = context.read<CachedProvider>();
  final itemProvider = context.read<ItemProvider>();

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

  if (cachedProvider.pointerPosition.dx > BODY_WIDTH ||
      cachedProvider.pointerPosition.dy > BODY_HEIGHT ||
      cachedProvider.pointerPosition.dx < 0 ||
      cachedProvider.pointerPosition.dy < 0) {
    return -1;
  }

  final REAL_BODY_WIDTH = BODY_WIDTH - Config.MAIN_BODY_MARGIN;

  final ROW_COUNT =
      REAL_BODY_WIDTH ~/
          (Config.TASK_ITEM_MAX_WIDTH + Config.MAIN_BODY_MARGIN) +
      1;
  final CELL_WIDTH = REAL_BODY_WIDTH / ROW_COUNT - Config.MAIN_BODY_MARGIN;
  final CELL_HEIGHT = CELL_WIDTH;

  final REAL_POINTER_POSITION =
      cachedProvider.pointerPosition +
      Offset(0.0, cachedProvider.mainBodyScrollOffset);

  final xIndex =
      REAL_POINTER_POSITION.dx ~/ (CELL_WIDTH + Config.MAIN_BODY_MARGIN);
  final yIndex =
      REAL_POINTER_POSITION.dy ~/ (CELL_HEIGHT + Config.MAIN_BODY_MARGIN);

  return min(
    max(yIndex * ROW_COUNT + xIndex, 0),
    itemProvider.list.length - 1,
  ).toInt();
}

void selectItem(BuildContext context) {
  final cachedProvider = context.read<CachedProvider>();

  if (cachedProvider.overlayIndex != 0 || cachedProvider.dialogIndex != 0)
    return;

  final itemProvider = context.read<ItemProvider>();

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

  if (cachedProvider.pointerPosition.dx > BODY_WIDTH ||
      cachedProvider.pointerPosition.dy > BODY_HEIGHT) {
    return;
  }

  final REAL_BODY_WIDTH = BODY_WIDTH - Config.MAIN_BODY_MARGIN;

  final ROW_COUNT =
      REAL_BODY_WIDTH ~/
          (Config.TASK_ITEM_MAX_WIDTH + Config.MAIN_BODY_MARGIN) +
      1;
  final CELL_WIDTH = REAL_BODY_WIDTH / ROW_COUNT - Config.MAIN_BODY_MARGIN;
  final CELL_HEIGHT = CELL_WIDTH;

  final REAL_POINTER_POSITION =
      cachedProvider.pointerPosition +
      Offset(0.0, cachedProvider.mainBodyScrollOffset);

  if (REAL_POINTER_POSITION.dx % (CELL_WIDTH + Config.MAIN_BODY_MARGIN) <=
      Config.MAIN_BODY_MARGIN) {
    return;
  }

  if (REAL_POINTER_POSITION.dy % (CELL_HEIGHT + Config.MAIN_BODY_MARGIN) <=
      Config.MAIN_BODY_MARGIN) {
    return;
  }

  final xIndex =
      REAL_POINTER_POSITION.dx ~/ (CELL_WIDTH + Config.MAIN_BODY_MARGIN);
  final yIndex =
      REAL_POINTER_POSITION.dy ~/ (CELL_HEIGHT + Config.MAIN_BODY_MARGIN);

  final index = (xIndex + yIndex * ROW_COUNT).toInt();

  print(index);

  final items = context.read<ItemProvider>().list;

  if (index >= items.length || index < 0) return;

  cachedProvider.selectedUUID = items[index].uuid;

  final xOrigin =
      (xIndex * (CELL_WIDTH + Config.MAIN_BODY_MARGIN)) +
      Config.MAIN_BODY_MARGIN;
  final yOrigin =
      yIndex * (CELL_HEIGHT + Config.MAIN_BODY_MARGIN) +
      Config.MAIN_BODY_MARGIN -
      cachedProvider.mainBodyScrollOffset;

  cachedProvider.draggedObjectOrigin = Offset(xOrigin, yOrigin);

  cachedProvider.draggedObject?.remove();
  cachedProvider.draggedObject = null;

  bool firstRun = true;
  final uuid = itemProvider.list[index].uuid;

  cachedProvider.draggedObject = OverlayEntry(
    builder: (_) {
      // if (cachedProvider.pointerDownOrigin == null) {
      //   print('check 1 failed');
      //   return SizedBox.expand();
      // }

      final origin = cachedProvider.draggedObjectOrigin;

      if (origin == null) {
        print('check 2 failed');
        return SizedBox.expand();
      }

      final offset = (firstRun || !cachedProvider.draggedObjectShouldBeVisible)
          ? Offset.zero
          : cachedProvider.pointerPosition - cachedProvider.pointerDownOrigin!;

      firstRun = false;

      return AnimatedPositioned(
        duration: Config.DRAGGED_OBJECT_IN_OUT_DURATION,
        curve: Curves.easeOutBack,
        left: origin.dx + offset.dx,
        top: origin.dy + offset.dy,
        width: CELL_WIDTH,
        height: CELL_HEIGHT,
        child: Material(
          color: Colors.transparent,
          child: Item.Class(uuid: uuid, dragging: true),
        ),
      );
    },
  );
}

void dragItem(BuildContext context) {
  final cachedProvider = context.read<CachedProvider>();
  final overlayEntry = cachedProvider.draggedObject;

  if (overlayEntry != null && !overlayEntry.mounted) {
    Overlay.of(context).insert(overlayEntry);

    cachedProvider.draggedObjectShouldBeVisible = true;
    cachedProvider.draggedObjectIsVisible = true;
    cachedProvider.draggedObjectIndex = getIndexAtCursor(context);
  }
}

void whileDrag(BuildContext context) {
  final cachedProvider = context.read<CachedProvider>();
  final itemProvider = context.read<ItemProvider>();

  final oldIndex = cachedProvider.draggedObjectIndex;
  final newIndex = getIndexAtCursor(context);

  if (oldIndex != null && newIndex != null && oldIndex != newIndex) {
    itemProvider.reorder(oldIndex, newIndex);
    cachedProvider.draggedObjectIndex = newIndex;
  }
}
