import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/data_type.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;

class Class extends StatefulWidget {
  final SingleTask item;
  const Class({super.key, required this.item});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: Config.DRAGGED_OBJECT_IN_OUT_DURATION,
  );
  late final _paddingAnim = Tween(
    begin: Config.ITEM_PADDING.NONE,
    end: Config.ITEM_PADDING.NONE,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
  late final _radiusAnim = Tween(
    begin: Config.CORNER.NONE,
    end: Config.CORNER.ROUND,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
  late final _streakPosition = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
  late final _streakSize = TweenSequence(
    [
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.4, end: 0.0), weight: 50),
    ],
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final item = widget.item;

    return GestureDetector(
      onTap: () {
        final cached = context.read<CachedProvider>();
        if (cached.selectedUUID != item.uuid) {
          cached.selectedUUID = item.uuid;
          // _controller.forward();
        } else {
          cached.selectedUUID = null;
          // _controller.reverse();
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Selector<CachedProvider, bool>(
          selector: (_, p) => p.selectedUUID == item.uuid,
          builder: (context, selected, child) {
            if (selected) {
              _controller.forward();
            } else {
              _controller.reverse();
            }

            return AnimatedBuilder(
              animation: _controller,
              builder: (_, _) {
                final background = colorScheme.secondaryContainer;
                final border = colorScheme.primary;

                return Container(
                  padding: EdgeInsets.all(_paddingAnim.value),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: border,
                      width: lerpDouble(
                        Config.BORDER_WIDTH.MEDIUM,
                        Config.BORDER_WIDTH.FOCUSED,
                        _controller.value,
                      )!,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.inverseSurface.withOpacity(
                          Config.BLUR_OPACITY.LESS * _controller.value,
                        ),
                        blurRadius: Config.BLUR_RADIUS.MEDIUM,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        background,
                        background,
                        border,
                        background,
                        background,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [
                        0.0,
                        _streakPosition.value - _streakSize.value,
                        _streakPosition.value,
                        _streakPosition.value + _streakSize.value,
                        1.0,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(_radiusAnim.value),
                  ),
                  child: Center(child: Text(item.name)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
