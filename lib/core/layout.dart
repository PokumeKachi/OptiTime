import 'package:flutter/material.dart';

import 'elements/body.dart' as Body;
import 'elements/nav_bar.dart' as NavBar;
import 'elements/overlay.dart' as Overlay;

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  final pageIndex = ValueNotifier<int>(0);

  void onNavigationButtonClick(int? targetIndex) {
    if (targetIndex == null) {
      return;
    }

    pageIndex.value = (pageIndex.value == targetIndex) ? 0 : targetIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Body.Class(),

          ValueListenableBuilder<int>(
            valueListenable: pageIndex,
            builder: (_, value, __) => Overlay.Class(pageIndex: value),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: NavBar.Class(clickEvent: onNavigationButtonClick),
            ),
          ),
        ],
      ),
    );
  }
}
