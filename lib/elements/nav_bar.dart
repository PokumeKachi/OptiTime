import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/provider.dart';
import 'dialog.dart' as Dialogs;

class _NavButton extends StatefulWidget {
  const _NavButton({super.key, required this.icon, this.targetIndex});

  final IconData icon;
  final int? targetIndex;

  static void handleClick(BuildContext context, int? targetIndex) {
    debugPrint('Target index of navigation button is $targetIndex');
    final overlayIndex = context.read<OverlayIndexProvider>();
    final dialogIndex = context.read<DialogIndexProvider>();

    if (targetIndex != null) {
      overlayIndex.value =
          overlayIndex.value == targetIndex ? 0 : targetIndex;
    } else {
      dialogIndex.value = 1;
    }
    // showGeneralDialog(
    //                   context: context,
    //                   barrierDismissible: true,
    //                   barrierLabel: "Dismiss dialog",
    //                   transitionDuration: const Duration(
    //                     milliseconds: Config.ANIMATION_DURATION,
    //                   ),
    //                   pageBuilder: (context, anim1, anim2) => _cachedDialog,
    //                   // Align(alignment: Alignment.center, child: _cachedDialog),
    //                   transitionBuilder: (context, anim1, anim2, child) =>
    //                       SlideTransition(
    //                         position:
    //                             Tween<Offset>(
    //                               begin: const Offset(0, -1),
    //                               end: Offset.zero,
    //                             ).animate(
    //                               CurvedAnimation(
    //                                 parent: anim1,
    //                                 curve: Curves.easeOutQuart,
    //                               ),
    //                             ),
    //                         child: ScaleTransition(
    //                           scale: Tween<double>(begin: 0.7, end: 1.0).animate(
    //                             CurvedAnimation(
    //                               parent: anim1,
    //                               curve: Curves.easeOutExpo,
    //                             ),
    //                           ),
    //                           child: FadeTransition(
    //                             opacity: Tween<double>(
    //                               begin: 0.0,
    //                               end: 1.0,
    //                             ).animate(anim1),
    //                             child: child,
    //                           ),
    //                         ),
    //                       ),
    //                 );
  }

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox.expand(
        child: IconButton(
          icon: Icon(widget.icon),
          onPressed: () => _NavButton.handleClick(context, widget.targetIndex),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Config.MIN_CORNER),
            ),
            elevation: widget.targetIndex == null ? 8 : 0,
            backgroundColor: widget.targetIndex == null
                ? Theme.of(context).colorScheme.tertiaryContainer
                : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class Class extends StatelessWidget {
  const Class({super.key});

  static const navItems = [
    {'icon': Icons.delete, 'target': 1},
    {'icon': Icons.energy_savings_leaf, 'target': 2},
    {'icon': Icons.add, 'target': null},
    {'icon': Icons.notifications, 'target': 3},
    {'icon': Icons.settings, 'target': 4},
  ];

  static final List<Widget> _cachedButtons = navItems.map((item) {
    final target = item['target'] as int?;
    return _NavButton(icon: item['icon'] as IconData, targetIndex: target);
  }).toList();

  @override
  Widget build(BuildContext context) {
    print('navbar rebuild');

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final portraitView = height > width;

    return Positioned(
      left: portraitView ? 0 : null,
      top: (!portraitView) ? 0 : null,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: portraitView
              ? height * Config.NAV_BAR_RATIO
              : double.infinity,
          width: (!portraitView)
              ? width * Config.NAV_BAR_RATIO
              : double.infinity,
          child: Flex(
            direction: portraitView ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: portraitView
                ? _cachedButtons
                : _cachedButtons.reversed.toList(),
          ),
        ),
      ),
    );
  }
}
