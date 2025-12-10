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

class ClassState extends State<Class> with TickerProviderStateMixin {
  late final _emailController = TextEditingController();
  late final _emailShakeController = AnimationController(
    vsync: this,
    duration: Config.ANIMATION.MEDIUM,
  );
  late final _emailShakeAnimation = Config.TWEEN.SHAKE.animate(
    CurvedAnimation(parent: _emailShakeController, curve: Curves.easeOut),
  );

  late final _passwordController = TextEditingController();
  late final _passwordShakeController = AnimationController(
    vsync: this,
    duration: Config.ANIMATION.MEDIUM,
  );
  late final _passwordShakeAnimation = Config.TWEEN.SHAKE.animate(
    CurvedAnimation(parent: _passwordShakeController, curve: Curves.easeOut),
  );

  static const SPACING = Config.DIALOG.SPACING;

  @override
  void initState() {
    super.initState();

    widget.keyEventProvider.addListener(_handleKey);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailShakeController.dispose();
    _passwordController.dispose();
    _passwordShakeController.dispose();
    widget.keyEventProvider.removeListener(_handleKey);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('sign in dialog rebuild');

    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    final formWidgets = [
      AnimatedBuilder(
        animation: _emailShakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_emailShakeAnimation.value, 0),
            child: child,
          );
        },
        child: TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: loc.signInDialogEmail,
            border: Config.getDialogInputBorder(context: context),
            enabledBorder: Config.getDialogInputBorder(context: context),
            focusedBorder: Config.getDialogInputBorder(
              context: context,
              focused: true,
            ),
          ),
        ),
      ),
      AnimatedBuilder(
        animation: _passwordShakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_passwordShakeAnimation.value, 0),
            child: child,
          );
        },
        child: TextField(
          obscureText: true,
          obscuringCharacter: '•',
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: loc.signInDialogPassword,
            border: Config.getDialogInputBorder(context: context),
            enabledBorder: Config.getDialogInputBorder(context: context),
            focusedBorder: Config.getDialogInputBorder(
              context: context,
              focused: true,
            ),
          ),
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
            loc.signInDialogLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Config.FONT_SIZE.BIG,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Config.DIALOG.TITLE_PADDING),

          Selector<CachedProvider, bool>(
            selector: (_, provider) => provider.dialogIndex == widget.index,
            builder: (context, visible, child) => Visibility(
              visible: visible,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...Stagger.dialog(children: formWidgets),
                  actionButtonRow,
                ],
              ),
            ),
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

    _emailController.text = "";
    _passwordController.text = "";
  }

  void _missingWarning(AnimationController controller) {
    controller.forward(from: 0);
  }

  void _confirm([String? _]) async {
    final loc = AppLocalizations.of(context)!;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty) {
      _missingWarning(_emailShakeController);
    }

    if (password.isEmpty) {
      _missingWarning(_passwordShakeController);
    }

    final res = await _Supabase.Auth.signInOrSignUp(email, password);

    if (res?.user?.id != null) {
      Notify.send(
        context: context,
        title: loc.signInSuccessNotificationTitle,
        subtitle: loc.signInSuccessNotificationSubtitle,
        accentColor: Colors.green,
        duration: Config.NOTIFICATION.MEDIUM,
      );

      _cancel();
    }
  }
}
