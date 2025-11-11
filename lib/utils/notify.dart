import 'package:flutter/material.dart';

import 'package:animated_snack_bar/animated_snack_bar.dart';

import 'package:todo/utils/config.dart' as Config;

void send({
  required BuildContext context,
  String content = "",
  Color accentColor = Colors.green,
  Duration duration = Config.NOTIFICATION.MEDIUM,
}) {
  AnimatedSnackBar(
    builder: ((context) {
      return const MaterialAnimatedSnackBar(
        titleText: 'Custom material snackbar ',
        messageText: 'This a custom material snackbar with info type',
        type: AnimatedSnackBarType.info,
        foregroundColor: Colors.amber,
        titleTextStyle: TextStyle(color: Colors.brown),
      );
    }),
  ).show(context);
}
