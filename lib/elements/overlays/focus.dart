import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:todo/l10n/app_localizations.dart';

import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/notify.dart' as Notify;
import 'package:todo/utils/supabase.dart' as _Supabase;

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  @override
  void initState() {
    super.initState();

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      context.read<CachedProvider>().addListener(() {
        final cached = context.read<CachedProvider>();
        if (cached.focusDuration != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            startKioskMode();
          });
        } else {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   stopKioskMode();
          // });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final storedProvider = context.read<StoredProvider>();
    final syncedProvider = context.read<SyncedProvider>();
    final cachedProvider = context.read<CachedProvider>();

    return Center(
      child: Selector<CachedProvider, Duration?>(
        selector: (_, p) => p.focusDuration,
        builder: (context, focusDuration, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (cachedProvider.selectedUUID != null) {
              cachedProvider.selectedUUID = null;
            }
          });

          if (focusDuration == null || cachedProvider.selectedUUID == null) {
            print(focusDuration);
            print('not fucosing');
            return Center(child: Text('tree'));
          }

          final item = syncedProvider.getItemFromUuid(
            cachedProvider.selectedUUID!,
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            cachedProvider.selectedUUID = null;
          });

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                item.name,
                style: TextStyle(fontSize: Config.FONT_SIZE.BIGGER),
              ),
              TimerCountdown(
                format: CountDownTimerFormat.hoursMinutesSeconds,
                endTime: DateTime.now().add(focusDuration),
                onEnd: () {
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  // cachedProvider.focusDuration = null;
                  // cachedProvider.overlayIndex = 0;
                  // });

                  if (mounted) cachedProvider.endFocusSession();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
