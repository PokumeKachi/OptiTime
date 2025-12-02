import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/supabase.dart' as _Supabase;

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  static const _themeModes = ['System', 'Light', 'Dark'];
  static final _items = _themeModes
      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
      .toList();

  @override
  Widget build(BuildContext context) {
    final storedProvider = context.read<StoredProvider>();
    final value = context.select<StoredProvider, String>((p) => p.appThemeMode);
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: Colors.transparent,
      child: Center(
        child: Column(
          children: [
            DropdownButton<String>(
              value: value,
              items: _items,
              onChanged: (newMode) {
                if (newMode != null) storedProvider.appThemeMode = newMode;
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
