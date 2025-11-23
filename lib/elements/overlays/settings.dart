import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/provider.dart';

class Class extends StatelessWidget {
  const Class({super.key});
  static const _themeModes = ['System', 'Light', 'Dark'];
  static final _items = _themeModes
      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
      .toList();

  @override
  Widget build(BuildContext context) {
    debugPrint('settings rebuild');

    final provider = context.read<ThemeModeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: Colors.transparent,
      child: Center(
        child: DropdownButton<String>(
          value: provider.themeMode,
          items: _items,
          onChanged: (newMode) {
            if (newMode != null) provider.changeThemeMode(newMode);
          },
        ),
      ),
    );
  }
}

