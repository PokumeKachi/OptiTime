import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'utils/config.dart' as Config;
import 'utils/provider.dart';

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
      body: Stack(
        children: [
          const Body.Class(),
          const Overlay.Class(),
          const NavBar.Class(),
          const Dialog.Class(),
        ],
      ),
    );
  }
}
