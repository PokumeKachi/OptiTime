import 'package:flutter/material.dart';

import 'package:todo/pages/settings.dart' as SettingsPage;

import 'nav_bar.dart' as NavBar;

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  int pageIndex = 0;

  void onNavigationButtonClick(int? targetIndex) {
    setState(() {
      if (targetIndex == null) {
        return;
      }

      if (pageIndex == targetIndex) {
        pageIndex = 0;
      } else {
        pageIndex = targetIndex;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final pages = [
      Container(),

      Container(
        color: colorScheme.background,
        child: Center(child: Text('trash bin')),
      ),

      Container(
        color: colorScheme.background,
        child: Center(child: Text('tree')),
      ),

      Container(
        color: colorScheme.tertiary,
        child: Center(child: Text('alarms')),
      ),

      SettingsPage.Class(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Column(children: [Text('todo task 1'), Text('todo task 2')]),

          AnimatedSwitcher(
            transitionBuilder: (child, animation) {
              final offsetAnim = Tween<Offset>(
                begin: const Offset(1.0, 0.0), // slide in from right
                end: Offset.zero,
              ).animate(animation);

              return SlideTransition(position: offsetAnim, child: child);
            },
            duration: const Duration(seconds: 5),
            child: KeyedSubtree(
              key: ValueKey(pageIndex),
              child: pages[pageIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar.Class(clickEvent: onNavigationButtonClick),
    );
  }
}
