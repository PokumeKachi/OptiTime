import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import 'core/layout.dart' as Layout;
import 'core/config.dart' as Config;
import 'core/provider.dart';

const themeModeMap = {
  'System': ThemeMode.system,
  'Light': ThemeMode.light,
  'Dark': ThemeMode.dark,
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final _storage = GetStorage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModeProvider>(
          create: (context) => ThemeModeProvider(_storage),
        ),
        ChangeNotifierProvider<TaskListProvider>(
          create: (context) => TaskListProvider(_storage),
        ),
        // ChangeNotifierProvider<OtherProvider>(
        //   create: (context) => OtherProvider(),
        // ),
        // add more providers here
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.TITLE,
      theme: ThemeData.from(colorScheme: Config.COLOR_SCHEME),
      darkTheme: ThemeData.from(colorScheme: Config.COLOR_SCHEME_DARK),
      themeMode:
          themeModeMap[Provider.of<ThemeModeProvider>(context).themeMode],
      // home: const SafeArea(child: Layout.Class(), top: false),
      home: Layout.Class(),
    );
  }
}
