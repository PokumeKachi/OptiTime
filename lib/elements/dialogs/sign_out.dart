import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/l10n/app_localizations.dart';

import 'package:todo/utils/supabase.dart' as _Supabase;
import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/notify.dart' as Notify;
import 'package:todo/utils/stagger.dart' as Stagger;
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/data_type.dart';

import 'shared/provider.dart';
import 'shared/action_button.dart' as ActionButton;
import 'shared/autocomplete.dart' as Autocomplete;

class Class extends StatefulWidget {
  final int index;
  final KeyEventProvider keyEventProvider;

  const Class({super.key, required this.index, required this.keyEventProvider});

  @override
  State<Class> createState() => ClassState();
}

class ClassState extends State<Class> with SingleTickerProviderStateMixin {
  static const SPACING = Config.DIALOG.SPACING;
  late AnimationController _flashController = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  );
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    widget.keyEventProvider.addListener(_handleKey);
  }

  @override
  void dispose() {
    widget.keyEventProvider.removeListener(_handleKey);
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('sign out dialog rebuild');
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    final _colorAnimation = ColorTween(begin: colorScheme.errorContainer, end: colorScheme.background)
        .animate(
          CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
        );

    final formWidgets = [
      Text(
        loc.signOutDialogWarning,
        style: TextStyle(color: colorScheme.onErrorContainer),
      ),
    ].expand((widget) => [widget, const SizedBox(height: SPACING)]).toList();

    final actionButtonRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: Stagger.dialog(
        offset: -1.0,
        children: [
          ActionButton.Class(
            text: loc.buttonCancel,
            icon: Icon(Icons.cancel),
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: colorScheme.error,
            ),
            callback: _cancel,
          ),
          ActionButton.Class(
            text: loc.buttonConfirm,
            icon: Icon(Icons.check),
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            callback: _confirm,
          ),
        ],
      ),
    );

    return AnimatedBuilder(
      animation: _flashController,
      builder: (context, child) {
        return Container(
          width: Config.DIALOG.WIDTH,
          padding: EdgeInsets.all(SPACING),
          decoration: BoxDecoration(
            color: _colorAnimation.value ?? colorScheme.background,
            borderRadius: BorderRadius.circular(Config.CORNER.ROUND),
          ),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            loc.signOutDialogLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Config.FONT_SIZE.BIG,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Config.DIALOG.TITLE_PADDING),
          Selector<CachedProvider, bool>(
            selector: (_, provider) => provider.dialogIndex == widget.index,
            builder: (context, visible, child) {
              // Trigger flash animation when becoming visible
              if (visible) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  _flashController.forward(from: 0.0);
                });
              }

              return Visibility(
                visible: visible,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...Stagger.dialog(children: formWidgets),
                    actionButtonRow,
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleKey() {
    if (!mounted) return;
    if (context.read<CachedProvider>().dialogIndex != widget.index) return;

    final event = widget.keyEventProvider.lastEvent;
    if (event == null) return;

    if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) _confirm();
      if (event.logicalKey == LogicalKeyboardKey.escape) _cancel();
    }
  }

  void _cancel() {
    FocusScope.of(context).unfocus();
    context.read<CachedProvider>().dialogIndex = 0;
  }

  void _confirm([String? _]) {
    final loc = AppLocalizations.of(context)!;
    Notify.send(
      context: context,
      title: loc.signOutSuccessNotificationTitle,
      subtitle: loc.signOutSuccessNotificationSubtitle,
      accentColor: Colors.green,
      duration: Config.NOTIFICATION.MEDIUM,
    );

    _Supabase.Auth.signOut().then((_) {}).catchError((e) {
      print('error during log out!');
      print(e);
    });

    _cancel();
  }
}
