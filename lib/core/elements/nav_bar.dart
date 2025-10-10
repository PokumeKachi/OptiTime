import 'package:flutter/material.dart';

class _NavButton extends StatelessWidget {
  const _NavButton({super.key, required this.icon, required this.onClick});

  final IconData icon;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox.expand(
        child: onClick == null
            ? ElevatedButton(onPressed: () {}, child: Icon(icon))
            : IconButton(icon: Icon(icon), onPressed: onClick),
      ),
    );
  }
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
    final height = MediaQuery.of(context).size.height * 0.08;

    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final target = item['target'] as int?;
          return _NavButton(
            icon: item['icon'] as IconData,
            onClick: target != null ? () => _handleClick(target) : null,
          );
        }).toList(),
      ),
    );
  }
}
