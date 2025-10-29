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

class Class extends StatelessWidget {
  const Class({super.key, required this.visible, required this.buttons});

  final bool visible;
  final List<Button> buttons;

  @override
  Widget build(BuildContext context) {
    debugPrint('action button row rebuild');

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        for (int i = 0; i < buttons.length; i++) ...[
          AnimatedSlide(
            offset: visible ? Offset.zero : Offset(.7 + .7 * i, 0),
            duration: Config.ANIMATION.VERY_LONG,
            curve: Curves.easeOutCubic,
            child: TextButton(
              onPressed: buttons[i].callback,
              style: buttons[i].style,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (buttons[i].icon != null) buttons[i].icon!,
                  if (buttons[i].icon != null && buttons[i].text != null)
                    const SizedBox(width: 4),
                  if (buttons[i].text != null) Text(buttons[i].text!),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
