import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/l10n/app_localizations.dart';
// import 'package:localization_i18n_arb/l10n/l10n.dart';

import 'layout.dart' as Layout;
import 'utils/config.dart' as Config;
import 'utils/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await GetStorage.init();

  await Supabase.initialize(
    url: 'https://qwfmauulihuwtraimelf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF3Zm1hdXVsaWh1d3RyYWltZWxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ2MDEzODQsImV4cCI6MjA4MDE3NzM4NH0.A4EaTF82qG2enGIzRiEbjrwQa0T-U_DT6GLDeMSVGHo',
  );

  // await GetStorage().erase();

  final providers = [
    ChangeNotifierProvider(create: (_) => ItemProvider()),
    ChangeNotifierProvider(create: (_) => StoredProvider()),
    ChangeNotifierProvider(create: (_) => CachedProvider()),
  ];

  runApp(MultiProvider(providers: providers, child: const App()));

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

    final themeMode = context.select<StoredProvider, ThemeMode>(
      (p) => p.appThemeMode,
    );

    final locale = context.select<StoredProvider, Locale>((p) => p.locale);

    return MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: Config.TITLE,
      theme: Config.THEME,
      darkTheme: Config.THEME_DARK,
      themeMode: themeMode,
      home: Layout.Class(),
    );
  }
}
