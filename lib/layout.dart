import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/provider.dart';
import 'dart:async';

import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/algorithm.dart' as Algorithms;
import 'elements/body.dart' as Body;
import 'elements/nav_bar.dart' as NavBar;
import 'elements/overlay.dart' as Overlay;
import 'elements/dialog.dart' as Dialog;

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
          cachedProvider.pointerDown = true;
          cachedProvider.pointerPosition = e.localPosition;
          cachedProvider.pointerDownOrigin = e.localPosition;

          if (clickTimer?.isActive ?? false) {
            clickTimer?.cancel();
          }

          clickTimer = Timer(Config.MAX_POINTER_CLICK_DURATION, () {
            cachedProvider.pointerDragging = true;
          });

          cachedProvider.selectedUUID = Algorithms.getUuidUnderPointer(context);
        },
        onPointerMove: (e) {
          cachedProvider.pointerPosition = e.localPosition;

          if ((e.localPosition - cachedProvider.pointerDownOrigin!).distance >
              Config.MIN_DRAG_DISTANCE) {
            cachedProvider.pointerDragging = true;
          }
        },
        onPointerUp: (e) {
          cachedProvider.pointerDown = false;
          cachedProvider.pointerPosition = e.localPosition;
          cachedProvider.pointerDownOrigin = null;

          // handle drag/click
          if (cachedProvider.pointerDragging) {
            // drag finished
          } else {
            // click finished
          }

          cachedProvider.selectedUUID = null;
          cachedProvider.pointerDragging = false;

          clickTimer?.cancel();
        },
        child: Stack(
          children: [
            const Body.Class(),
            const Overlay.Class(),
            const NavBar.Class(),
            const Dialog.Class(),
          ],
        ),
      ),
    );
  }
}
