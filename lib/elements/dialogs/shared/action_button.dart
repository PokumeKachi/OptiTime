import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/data_type.dart';
import 'package:todo/utils/provider.dart';
import 'package:todo/utils/config.dart' as Config;

class Class extends StatelessWidget {
  const Class({
    super.key,
    this.text,
    this.icon,
    this.callback = _defaultCallback,
    this.style = const ButtonStyle(),
  });

  final String? text;
  final Icon? icon;
  final VoidCallback callback;
  final ButtonStyle style;

  static void _defaultCallback() {
    debugPrint('Button callback received!');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('action button row rebuild');

    return TextButton(
      onPressed: callback,
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null && text != null) const SizedBox(width: 4),
          if (text != null) Text(text!),
        ],
      ),
    );
  }
}
