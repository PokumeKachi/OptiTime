import 'package:flutter/material.dart';

import 'elements/body.dart' as Body;
import 'elements/nav_bar.dart' as NavBar;
import 'elements/overlay.dart' as Overlay;

import 'utils/config.dart' as Config;

class Class extends StatelessWidget {
  const Class({super.key});

  @override
  Widget build(BuildContext context) {
    print('layout rebuild');
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          const Body.Class(),
          const Overlay.Class(),
          const NavBar.Class(),
        ],
      ),
    );
  }
}
