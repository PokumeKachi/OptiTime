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
  static const List<String> themeModes = ['System', 'Light', 'Dark'];
  String selectedThemeMode = GetStorage().read('themeMode') ?? themeModes[0];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox.expand(
      child: Container(
        color: colorScheme.secondaryContainer,
        child: Row(
          children: [
            DropdownButton<String>(
              value: selectedThemeMode,
              hint: Text('Select an option'),
              items: themeModes.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (value) {
                selectedThemeMode = value ?? 'System';

                Provider.of<ThemeModeProvider>(
                  context,
                  listen: false,
                ).changeThemeMode(value!);

                GetStorage().write('themeMode', value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
