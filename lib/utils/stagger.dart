import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:todo/utils/config.dart' as Config;

List<Widget> dialog({
  required List<Widget> children,
  double offset = 1.0,
}) {
  return AnimationConfiguration.toStaggeredList(
    duration: Config.STAGGER_DURATION,
    childAnimationBuilder: (widget) => SlideAnimation(
      curve: Curves.easeOutQuart,
      duration: Config.STAGGER_DURATION,
      horizontalOffset: Config.DIALOG_STAGGER_OFFSET * offset,
      child: FadeInAnimation(
        duration: Config.DIALOG_IN_OUT_DURATION,
        child: widget,
      ),
    ),
    children: children,
  );
}
