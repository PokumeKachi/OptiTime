import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/data_type.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;

class Class extends StatefulWidget {
  final int uuid;
  const Class({super.key, required this.uuid});
  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Config.DRAGGED_OBJECT_IN_OUT_DURATION,
  );

  late final Animation<double> _paddingAnim = Tween<double>(
    begin: Config.ITEM_PADDING.NARROWEST,
    end: Config.ITEM_PADDING.WIDER,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

  late final Animation<double> _radiusAnim = Tween<double>(
    begin: Config.CORNER.NONE,
    end: Config.CORNER.ROUNDEST,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

  late final Animation<double> _streakPosition = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

  late final Animation<double> _streakSize = TweenSequence(
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

    final items = context.watch<ItemProvider>().list;
    final item =
        items[context.read<ItemProvider>().getIndexOfUuid(widget.uuid)];

    late final itemWidget;

    final itemWidgetFactory = (childWidget) {
      return childWidget;
    };

    final singleTaskWidgetFactory = (SingleTask taskInfo) {
      return itemWidgetFactory(Text(taskInfo.name));
    };

    final groupTaskWidgetFactory = (GroupTask groupInfo) {
      return itemWidgetFactory(
        ListView.builder(
          physics: Config.SCROLL_PHYSICS,
          itemCount: groupInfo.tasks.length,
          itemBuilder: (context, index) {
            return singleTaskWidgetFactory(groupInfo.tasks[index]);
          },
        ),
      );
    };

    if (item is SingleTask) {
      itemWidget = singleTaskWidgetFactory(item);
    } else if (item is GroupTask) {
      itemWidget = groupTaskWidgetFactory(item);
    }
    return GestureDetector(
      onTap: () {
        final cachedProvider = context.read<CachedProvider>();

        if (cachedProvider.selectedUUID != widget.uuid) {
          cachedProvider.selectedUUID = widget.uuid;
          _controller.forward();
          print('case 3');

          // cachedProvider.addListener(() {
          //   if (cachedProvider.selectedUUID != widget.uuid) {
          //     cachedProvider.selectedUUID = null;
          //     _controller.reverse();
          //     print('case 2');
          //   }
          // });
        } else {
          cachedProvider.selectedUUID = null;
          _controller.reverse();
          print('case 1');
        }
      },
      child: SizedBox.expand(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final backgroundColor = item is SingleTask
                  ? colorScheme.secondaryContainer
                  : colorScheme.tertiaryContainer;

              final secondaryColor = item is SingleTask
                  ? colorScheme.primary
                  : colorScheme.tertiary;
              return Container(
                padding: EdgeInsets.all(_paddingAnim.value),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: secondaryColor,
                    width:
                        lerpDouble(
                          Config.BORDER_WIDTH.MEDIUM,
                          Config.BORDER_WIDTH.FOCUSED,
                          _controller.value,
                        ) ??
                        Config.BORDER_WIDTH.MEDIUM,
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
                      backgroundColor,
                      backgroundColor,
                      secondaryColor,
                      backgroundColor,
                      backgroundColor,
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
                child: itemWidget,
              );
            },
          ),
        ),
      ),
    );
  }
}
