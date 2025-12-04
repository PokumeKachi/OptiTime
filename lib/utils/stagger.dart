import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:todo/utils/config.dart' as Config;

List<Widget> dialog({
  required List<Widget> children,
  double offset = 1.0,
}) {
  return AnimationConfiguration.toStaggeredList(
    duration: Config.DIALOG.IN_OUT_DURATION,
    childAnimationBuilder: (widget) => SlideAnimation(
      curve: Curves.easeOutQuart,
      duration: Config.DIALOG.STAGGER_DURATION,
      horizontalOffset: Config.DIALOG.STAGGER_OFFSET * offset,
      child: FadeInAnimation(
        duration: Config.DIALOG.IN_OUT_DURATION,
        child: widget,
      ),
    ),
    children: children,
  );
}
