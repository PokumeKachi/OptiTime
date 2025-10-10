import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/provider.dart';

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  static const themeModes = ['System', 'Light', 'Dark'];
  late String selectedThemeMode;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    selectedThemeMode = storage.read('themeMode') ?? themeModes[0];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.secondaryContainer,
      child: Center(
        child: DropdownButton<String>(
          value: selectedThemeMode,
          items: themeModes
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (newThemeSelection) {
            if (newThemeSelection == null) return;
            setState(() => selectedThemeMode = newThemeSelection);
            Provider.of<ThemeModeProvider>(
              context,
              listen: false,
            ).changeThemeMode(newThemeSelection);
            storage.write('themeMode', newThemeSelection);
          },
        ),
      ),
    );
  }
}
