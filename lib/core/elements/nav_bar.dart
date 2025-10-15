import 'package:flutter/material.dart';


import 'package:todo/core/config.dart' as Config;
import 'dialogs.dart' as Dialogs;

class _NavButton extends StatefulWidget {
  const _NavButton({
    super.key,
    required this.icon,
    required this.onClick,
    this.targetIndex,
  });

  final IconData icon;
  final VoidCallback? onClick;
  final int? targetIndex;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  @override
  Widget build(BuildContext context) => Expanded(
      child: SizedBox.expand(
        child: widget.onClick == null
            ? ElevatedButton(
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: "Dismiss dialog",
                    transitionDuration: const Duration(
                      milliseconds: Config.ANIMATION_DURATION,
                    ),
                    pageBuilder: (context, anim1, anim2) => Align(
                      alignment: Alignment.center,
                      child: Dialogs.NewTask(),
                    ),
                    transitionBuilder: (context, anim1, anim2, child) =>
                        SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, -1),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: anim1,
                                  curve: Curves.easeOutQuart,
                                ),
                              ),
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.7, end: 1.0).animate(
                              CurvedAnimation(
                                parent: anim1,
                                curve: Curves.easeOutExpo,
                              ),
                            ),
                            child: FadeTransition(
                              opacity: Tween<double>(
                                begin: 0.0,
                                end: 1.0,
                              ).animate(anim1),
                              child: child,
                            ),
                          ),
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Config.MIN_CORNER),
                  ),
                  elevation: 8,
                ),
                child: Icon(widget.icon),
              )
            : IconButton(
                icon: Icon(widget.icon),
                onPressed: widget.onClick,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        widget.targetIndex == 1
                            ? Config.MAX_CORNER
                            : Config.MIN_CORNER,
                      ),
                      bottomLeft: Radius.circular(
                        widget.targetIndex == 1
                            ? Config.MAX_CORNER
                            : Config.MIN_CORNER,
                      ),
                      topRight: Radius.circular(
                        widget.targetIndex == 4
                            ? Config.MAX_CORNER
                            : Config.MIN_CORNER,
                      ),
                      bottomRight: Radius.circular(
                        widget.targetIndex == 4
                            ? Config.MAX_CORNER
                            : Config.MIN_CORNER,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
}

class Class extends StatelessWidget {
  const Class({super.key, required this.clickEvent});

  final ValueChanged<int?> clickEvent;

  static const navItems = [
    {'icon': Icons.delete, 'target': 1},
    {'icon': Icons.energy_savings_leaf, 'target': 2},
    {'icon': Icons.add, 'target': null},
    {'icon': Icons.notifications, 'target': 3},
    {'icon': Icons.settings, 'target': 4},
  ];

  void _handleClick(int? target) => clickEvent(target);

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height * Config.NAV_BAR_HEIGHT_RATIO;

    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final target = item['target'] as int?;
          return _NavButton(
            icon: item['icon'] as IconData,
            targetIndex: target,
            onClick: target != null ? () => _handleClick(target) : null,
          );
        }).toList(),
      ),
    );
  }
}
