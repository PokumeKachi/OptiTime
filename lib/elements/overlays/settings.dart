import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/main.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/supabase.dart' as _Supabase;
import 'package:todo/utils/config.dart' as Config;

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  @override
  Widget build(BuildContext context) {
    final storedProvider = context.read<StoredProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    final _themeModeItems = ThemeMode.values.map((m) {
      final text = switch (m) {
        ThemeMode.system => AppLocalizations.of(context)!.systemThemeMode,
        ThemeMode.light => AppLocalizations.of(context)!.lightThemeMode,
        ThemeMode.dark => AppLocalizations.of(context)!.darkThemeMode,
      };
      return DropdownMenuItem(value: m, child: Text(text));
    }).toList();
    final themeMode = context.select<StoredProvider, ThemeMode>(
      (p) => p.appThemeMode,
    );
    final _localeItems = AppLocalizations.supportedLocales.map((locale) {
      final name = locale.language;

      return DropdownMenuItem(value: locale, child: Text(name));
    }).toList();
    final locale = context.select<StoredProvider, Locale>((p) => p.locale);

    return ColoredBox(
      color: Colors.transparent,
      child: Center(
        child: Column(
          children: [
            DropdownButton<ThemeMode>(
              items: _themeModeItems,
              value: themeMode,
              onChanged: (newMode) {
                if (newMode != null) storedProvider.appThemeMode = newMode;
              },
            ),
            DropdownButton<String>(
              items: _localeItems,
              value: locale,
              onChanged: (newLocale) {
                if (newLocale != null) storedProvider.locale = newLocale;
              },
            ),
            TextButton(
              onPressed: () async {
                final cachedProvider = context.read<CachedProvider>();
                final itemProvider = context.read<ItemProvider>();

                if (cachedProvider.userId == null) {
                  final res = await _Supabase.Auth.signInOrSignUp(
                    'enene@gmail',
                    'roblox',
                  );
                  cachedProvider.userId = res?.user?.id;

                  if (cachedProvider.userId != null) {
                    itemProvider.listenToSupabase(cachedProvider.userId!);
                  }
                } else {
                  _Supabase.Auth.signOut()
                      .then((_) {
                        cachedProvider.userId = null;
                      })
                      .catchError((e) {
                        print('error during log out!');
                        print(e);
                      });
                }
              },
              child: Text('click me lil nga'),
            ),
            StreamBuilder(
              stream: Supabase.instance.client.auth.onAuthStateChange,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('nahhh');
                }

                final session = snapshot.hasData
                    ? snapshot.data!.session
                    : null;

                if (session == null) {
                  return Text('log');
                } else {
                  return Text(session.user.email.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
