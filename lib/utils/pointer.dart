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

void selectItem(BuildContext context) {
  final cachedProvider = context.read<CachedProvider>();

  if (cachedProvider.overlayIndex != 0 || cachedProvider.dialogIndex != 0)
    return;

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
    // Check if we're clicking on the margin gap
    return;
  }

  if (REAL_POINTER_POSITION.dy % (CELL_HEIGHT + Config.MAIN_BODY_MARGIN) <=
      Config.MAIN_BODY_MARGIN) {
    // Check if we're clicking on the margin gap
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
  // cachedProvider.draggedObjectIndex = index;

  final xOrigin =
      (xIndex * (CELL_WIDTH + Config.MAIN_BODY_MARGIN)) +
      Config.MAIN_BODY_MARGIN;
  final yOrigin =
      yIndex * (CELL_HEIGHT + Config.MAIN_BODY_MARGIN) +
      Config.MAIN_BODY_MARGIN -
      cachedProvider.mainBodyScrollOffset;

  cachedProvider.draggedObjectOrigin = Offset(xOrigin, yOrigin);

  cachedProvider.draggedObject = OverlayEntry(
    builder: (_) {
      // return SizedBox(
      //   width: CELL_WIDTH,
      //   height: CELL_HEIGHT,
      //   // child: Item.Class(index: index),
      // );

      if (cachedProvider.pointerDownOrigin == null) {
        return SizedBox.expand();
      }

      final origin = cachedProvider.draggedObjectOrigin;

      if (origin == null) {
        return SizedBox.expand();
      }

      final offset =
          cachedProvider.pointerPosition - cachedProvider.pointerDownOrigin!;

      return Positioned(
        left: origin.dx + offset.dx,
        top: origin.dy + offset.dy,
        width: CELL_WIDTH,
        height: CELL_HEIGHT,
        child: Material(
          color: Colors.transparent,
          child: Item.Class(index: index, dragging: true),
        ),
      );
    },
  );
}

void dragItem(BuildContext context) {
  final cachedProvider = context.read<CachedProvider>();
  Overlay.of(context).insert(cachedProvider.draggedObject!);
}
