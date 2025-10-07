import 'package:flutter/material.dart';

class _NavButton extends StatefulWidget {
  const _NavButton({
    super.key,
    required this.icon,
    required this.targetIndex,
    required this.clickEvent,
  });

  final Icon icon;
  final int? targetIndex;
  final ValueChanged<int?> clickEvent;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox.expand(
        child: (widget.targetIndex == null)
            ? ElevatedButton.icon(label: widget.icon, onPressed: () {})
            : IconButton(
                icon: widget.icon,
                onPressed: () {
                  widget.clickEvent(widget.targetIndex);
                },
              ),
      ),
    );
  }
}

class Class extends StatefulWidget {
  const Class({super.key, required this.clickEvent});

  final ValueChanged<int?> clickEvent;

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  static const navItems = [
    {'icon': Icons.delete, 'target': 1},
    {'icon': Icons.energy_savings_leaf, 'target': 2},
    {'icon': Icons.add, 'target': null},
    {'icon': Icons.notifications, 'target': 3},
    {'icon': Icons.settings, 'target': 4},
  ];

>>>>>>> resign-temp
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
<<<<<<< HEAD
        children: navItems.map((item) {
          return _NavButton(
            icon: Icon(item['icon'] as IconData),
            targetIndex: item['target'] as int?,
            clickEvent: widget.clickEvent,
          );
        }).toList(),
      ),
    );
  }
}
