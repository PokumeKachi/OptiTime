import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:todo/l10n/app_localizations.dart';

import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/supabase.dart' as _Supabase;

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  late Future<List<DropdownMenuItem<Locale>>> _localeItemsFuture =
      _loadLocaleItems();

  static Future<List<DropdownMenuItem<Locale>>> _loadLocaleItems() async {
    return Future.wait(
      AppLocalizations.supportedLocales.map((locale) async {
        final localization = await AppLocalizations.delegate.load(locale);
        return DropdownMenuItem<Locale>(
          value: locale,
          child: Text(localization.language),
        );
      }),
    );
  }

  Widget buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    double width = 200,
    required BuildContext context,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        items: items,
        value: value,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 48,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Config.CORNER.MEDIUM),
            border: Border.all(
              // color: colorScheme.outline,
              color: colorScheme.primary,
              width: Config.BORDER_WIDTH.MEDIUM,
            ),
            color: colorScheme.secondaryContainer,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: width,
          openInterval: Interval(0.0, 0.5, curve: Curves.easeOutQuad),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Config.CORNER.MEDIUM),
            border: Border.all(
              color: colorScheme.onSecondaryContainer,
              width: Config.BORDER_WIDTH.MEDIUM,
            ),

            color: colorScheme.secondaryContainer,
          ),
          // scrollbarTheme: ScrollbarThemeData(
          //   radius: const Radius.circular(Config.CORNER.MEDIUM),
          //   thickness: MaterialStateProperty.all(6),
          //   thumbColor: MaterialStateProperty.all(Colors.blue.shade200),
          // ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final storedProvider = context.read<StoredProvider>();
    final cachedProvider = context.read<CachedProvider>();

    final themeMode = context.select<StoredProvider, ThemeMode>(
      (p) => p.appThemeMode,
    );
    final locale = context.select<StoredProvider, Locale>((p) => p.locale);

    final _themeModeItems = ThemeMode.values.map((m) {
      final text = switch (m) {
        ThemeMode.system => loc.systemThemeMode,
        ThemeMode.light => loc.lightThemeMode,
        ThemeMode.dark => loc.darkThemeMode,
      };
      return DropdownMenuItem<ThemeMode>(value: m, child: Text(text));
    }).toList();

    return ColoredBox(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildDropdown<ThemeMode>(
              value: themeMode,
              items: _themeModeItems,
              onChanged: (v) => storedProvider.appThemeMode = v!,
              context: context,
            ),

            const SizedBox(height: Config.ITEM_PADDING.NARROW),

            FutureBuilder<List<DropdownMenuItem<Locale>>>(
              future: _localeItemsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return buildDropdown<Locale>(
                  value: locale,
                  items: snapshot.data!,
                  onChanged: (v) => storedProvider.locale = v!,
                  context: context,
                );
              },
            ),

            // const SizedBox(height: Config.ITEM_PADDING.NARROW),
            //
            // TextButton(
            //   onPressed: () {
            //     GetStorage().erase();
            //   },
            //   child: Text('Delete Data'),
            // ),
            const SizedBox(height: Config.ITEM_PADDING.NARROW),

            TextButton(
              onPressed: () async {
                final itemProvider = context.read<ItemProvider>();
                final user = Supabase.instance.client.auth.currentUser;
                if (user == null) {
                  final res = await _Supabase.Auth.signInOrSignUp(
                    'enene@gmail',
                    'roblox',
                  );
                  final userId = res?.user?.id;
                  if (userId != null) {
                    itemProvider.listenToSupabase(userId!);
                  }
                } else {
                  print('else what??');
                }
              },
              child: const Text('click me lil nga'),
            ),

            const SizedBox(height: Config.ITEM_PADDING.NARROW),

            StreamBuilder(
              stream: Supabase.instance.client.auth.onAuthStateChange,
              builder: (context, snapshot) {
                final session = snapshot.hasData
                    ? snapshot.data!.session
                    : null;

                late final void Function() onPressed;
                late final String text;

                if (session == null) {
                  onPressed = () {
                    print('sign in now');
                    cachedProvider.dialogIndex = 2;
                  };
                  text = loc.signInButton;
                } else {
                  onPressed = () {
                    print('signed in now');
                    cachedProvider.dialogIndex = 3;
                  };
                  text = loc.signedInLabel(session.user.email!);
                }

                return TextButton(onPressed: onPressed, child: Text(text));
              },
            ),
          ],
        ),
      ),
    );
  }
}
