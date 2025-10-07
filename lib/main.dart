import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:provider/provider.dart';

import 'core/layout.dart' as Layout;
import 'core/config.dart' as Config;
import 'core/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModeProvider>(
          create: (context) => ThemeModeProvider(),
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
      themeMode: Provider.of<ThemeModeProvider>(context).themeMode,
      home: const SafeArea(child: Layout.Class()),
    );
  }
}
