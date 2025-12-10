import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wheel_picker/wheel_picker.dart';
import 'package:todo/l10n/app_localizations.dart';

import 'package:todo/utils/supabase.dart' as _Supabase;
import 'package:todo/utils/config.dart' as Config;
import 'package:todo/utils/notify.dart' as Notify;
import 'package:todo/utils/stagger.dart' as Stagger;
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/data_type.dart';

import 'shared/provider.dart';
import 'shared/action_button.dart' as ActionButton;

class Class extends StatefulWidget {
  final int index;
  final KeyEventProvider keyEventProvider;

  const Class({super.key, required this.index, required this.keyEventProvider});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> with SingleTickerProviderStateMixin {
  static const SPACING = Config.DIALOG.SPACING;

  late final wheelControllers = [
    WheelPickerController(itemCount: 24),
    WheelPickerController(itemCount: 60),
    WheelPickerController(itemCount: 60),
  ];

  @override
  void initState() {
    super.initState();
    widget.keyEventProvider.addListener(_handleKey);
  }

  @override
  void dispose() {
    widget.keyEventProvider.removeListener(_handleKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('sign out dialog rebuild');
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    final wheelTextStyle = TextStyle(
      fontSize: Config.FONT_SIZE.MEDIUM,
      height: 1.5,
    );

    final formWidgets = [
      Text(
        loc.timerDialogDescription,
        style: TextStyle(color: colorScheme.onSurface),
      ),
      SizedBox(
        height: 100,
        child: Row(
          children: wheelControllers
              .map(
                (controller) => Expanded(
                  child: WheelPicker(
                    builder: (context, index) => Text(
                      index.toString().padLeft(2, '0'),
                      style: wheelTextStyle,
                    ),
                    controller: controller,
                    selectedIndexColor: colorScheme.primary,
                    onIndexChanged: (index, interactionType) =>
                        print("On index $index"),
                    style: WheelPickerStyle(
                      itemExtent:
                          wheelTextStyle.fontSize! * wheelTextStyle.height!,
                      squeeze: 1.25,
                      diameterRatio: .8,
                      surroundingOpacity: .2,
                      magnification: 1.5,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
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

    return Container(
      width: Config.DIALOG.WIDTH,
      padding: EdgeInsets.all(SPACING),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(Config.CORNER.ROUND),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            loc.timerDialogLabel,
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
    final cachedProvider = context.read<CachedProvider>();

    cachedProvider.focusDuration = Duration(
      hours: wheelControllers[0].selected,
      minutes: wheelControllers[1].selected,
      seconds: wheelControllers[2].selected,
    );
    cachedProvider.overlayIndex = 2;

    _cancel();
  }
}
