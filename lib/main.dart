import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'layout.dart' as Layout;
import 'utils/config.dart' as Config;
import 'utils/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await GetStorage.init();

  // await GetStorage().erase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<StoredProvider>(
          create: (context) => StoredProvider(),
        ),
        ChangeNotifierProvider<CachedProvider>(
          create: (context) => CachedProvider(),
        ),
      ],
      child: const App(),
    ),
  );

  doWhenWindowReady(() {
    // const initialSize = Size(600, 450);
    // appWindow.minSize = initialSize;
    // appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
    appWindow.maximize();
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('app rebuild');

    final themeMode = context.select<StoredProvider, ThemeMode>((p) {
      return switch (p.appThemeMode) {
        'Light' => ThemeMode.light,
        'Dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
    });

    return MaterialApp(
      title: Config.TITLE,
      theme: Config.THEME,
      darkTheme: Config.THEME_DARK,
      themeMode: themeMode,
      home: Layout.Class(),
    );
  }
}
