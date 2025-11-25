import 'package:flutter/material.dart';

import 'elements/body.dart' as Body;
import 'elements/nav_bar.dart' as NavBar;
import 'elements/overlay.dart' as Overlay;
import 'elements/dialog.dart' as Dialog;

class Class extends StatelessWidget {
  const Class({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('layout rebuild');

    return Scaffold(
      body: Listener(
        // onPointerDown: (e) => print('down at ${e.globalPosition}'),
        // onPointerMove: (e) => print('move at ${e.globalPosition}'),
        // onPointerUp: (e) => print('up at ${e.globalPosition}'),
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
