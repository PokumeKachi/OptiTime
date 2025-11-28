import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'utils/config.dart' as Config;
import 'utils/provider.dart';

import 'elements/body/pointer_logic.dart' as Pointer;
import 'elements/body.dart' as Body;
import 'elements/nav_bar.dart' as NavBar;
import 'elements/overlay.dart' as CustomOverlay;
import 'elements/dialog.dart' as Dialog;

void startDrag(BuildContext context) {
  final cachedProvider = context.read<CachedProvider>();
  cachedProvider.pointerDragging = true;
  Pointer.dragItem(context);
}

bool isTouch(PointerEvent e) {
  return e.kind == PointerDeviceKind.touch ||
      e.kind == PointerDeviceKind.stylus;
}

class Class extends StatelessWidget {
  const Class({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('layout rebuild');

    final cachedProvider = context.read<CachedProvider>();
    Timer? clickTimer;

    return Scaffold(
      body: Listener(
        onPointerDown: (e) {
          if (cachedProvider.pointerDown) return;

          cachedProvider.pointerDown = true;
          cachedProvider.pointerPosition = e.localPosition;
          cachedProvider.pointerDownOrigin = e.localPosition;

          if (clickTimer?.isActive ?? false) {
            clickTimer?.cancel();
          }

          clickTimer = Timer(
            isTouch(e)
                ? Config.MAX_POINTER_TAP_DURATION
                : Config.MAX_POINTER_CLICK_DURATION,
            () {
              if (!cachedProvider.pointerDragging) startDrag(context);
            },
          );

          Pointer.selectItem(context);
          // Algorithms.getUuidUnderPointer(context);
        },
        onPointerMove: (e) {
          if (!cachedProvider.pointerDown) return;

          final pointerMoved =
              e.localPosition != cachedProvider.pointerPosition;

          cachedProvider.pointerPosition = e.localPosition;

          final offset = cachedProvider.pointerDownOrigin != null
              ? cachedProvider.pointerPosition -
                    cachedProvider.pointerDownOrigin!
              : Offset.zero;

          if (offset.distance > Config.MIN_DRAG_DISTANCE &&
              !cachedProvider.pointerDragging &&
              !isTouch(e))
            startDrag(context);

          if (pointerMoved) cachedProvider.draggedObject?.markNeedsBuild();

          Pointer.whileDrag(context);
        },
        onPointerUp: (e) {
          if (!cachedProvider.pointerDown) return;

          cachedProvider.pointerDown = false;
          cachedProvider.pointerPosition = e.localPosition;
          cachedProvider.pointerDownOrigin = null;
          clickTimer?.cancel();

          // handle drag/click
          if (cachedProvider.pointerDragging) {
            // drag finished
          } else {
            // click finished
          }

          cachedProvider.pointerDragging = false;

          if (cachedProvider.draggedObject?.mounted ?? false) {
            cachedProvider.draggedObjectShouldBeVisible = false;
            cachedProvider.draggedObject?.markNeedsBuild();
            print('yuh gone');

            Future.delayed(Config.DRAGGED_OBJECT_IN_OUT_DURATION, () {
              print('yuh almost gone');
              cachedProvider.draggedObjectIsVisible = false;

              if (cachedProvider.draggedObject?.mounted ?? false)
                cachedProvider.draggedObject?.remove();

              cachedProvider.draggedObject = null;
              cachedProvider.draggedObjectOrigin = null;
              cachedProvider.draggedObjectIndex = null;
              cachedProvider.selectedUUID = null;
            });
          } else {
            print('manual');
            cachedProvider.draggedObject = null;
            cachedProvider.draggedObjectOrigin = null;
            cachedProvider.draggedObjectIndex = null;
            cachedProvider.selectedUUID = null;
          }
        },
        child: Stack(
          children: [
            const Body.Class(),
            const CustomOverlay.Class(),
            const NavBar.Class(),
            const Dialog.Class(),
          ],
        ),
      ),
    );
  }
}
