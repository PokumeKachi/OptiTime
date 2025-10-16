import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:provider/provider.dart';

import 'layout.dart' as Layout;
import 'utils/config.dart' as Config;
import 'utils/provider.dart';

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
        ChangeNotifierProvider<OverlayIndexProvider>(
          create: (context) => OverlayIndexProvider(0),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});
  static final lightTheme = ThemeData.from(colorScheme: Config.COLOR_SCHEME);
  static final darkTheme = ThemeData.from(
    colorScheme: Config.COLOR_SCHEME_DARK,
  );

  @override
  Widget build(BuildContext context) {
    print('app rebuild');

    final themeMode = switch (context.watch<ThemeModeProvider>().themeMode) {
      'Light' => ThemeMode.light,
      'Dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    return MaterialApp(
      title: Config.TITLE,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: Layout.Class(),
    );
  }
}
