import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/task.dart';
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/config.dart' as Config;

class Button {
  final String? text;
  final Icon? icon;
  final VoidCallback callback;
  final ButtonStyle style;

  Button({
    this.text,
    this.icon,
    this.callback = _defaultCallback,
    this.style = const ButtonStyle(),
  });

  static void _defaultCallback() {
    debugPrint('Button callback received!');
  }
}

class Class extends StatefulWidget {
  const Class({super.key, required this.visible, required this.buttons});

  final bool visible;
  final List<Button> buttons;

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  @override
  Widget build(BuildContext context) {
    debugPrint('action button row rebuild');
    final dialogIndex = context.read<DialogIndexProvider>();
    final buttons = widget.buttons;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        for (int i = 0; i < buttons.length; i++) ...[
          AnimatedSlide(
            offset: widget.visible ? Offset.zero : Offset(.5 + .5 * i, 0),
            duration: const Duration(
              milliseconds: Config.ANIMATION_DURATION * 3,
            ),
            curve: Curves.easeOutExpo,
            child: TextButton(
              onPressed: buttons[i].callback,
              style: buttons[i].style,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (buttons[i].icon != null) ...[buttons[i].icon!],
                  if (buttons[i].icon != null && buttons[i].text != null) ...[
                    const SizedBox(width: 4),
                  ],
                  if (buttons[i].text != null) ...[Text(buttons[i].text!)],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
