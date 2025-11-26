import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/data_type.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;

import 'parallax.dart' as Parallax;

class Class extends StatefulWidget {
  final int index;
  final bool dragging;
  const Class({super.key, required this.index, this.dragging = false});
  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Config.ANIMATION.LONG,
  );
  late final Animation<double> _paddingAnim = Tween<double>(
    begin: Config.ITEM_PADDING.NARROWEST,
    end: Config.ITEM_PADDING.WIDER,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  late final Animation<double> _radiusAnim = Tween<double>(
    begin: Config.CORNER.NONE,
    end: Config.CORNER.ROUNDEST,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  late final Animation<double> _streakPosition =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutCubicEmphasized,
        ),
      );

  // late final Animation<double> _streakSize = Tween<double>(
  //   begin: 0.0,
  //   end: 0.0,
  // ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  late final Animation<double> _streakSize = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.4), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 0.4, end: 0.0), weight: 50),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();

    if (widget.dragging) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant Class oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dragging != oldWidget.dragging) {
      widget.dragging ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final items = context.watch<ItemProvider>().list;
    final item = items[widget.index];

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
    return SizedBox.expand(
      child: MouseRegion(
        cursor: widget.dragging
            ? SystemMouseCursors.none
            : SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // return Parallax.Class();
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
                  width: lerpDouble(
                    Config.BORDER_WIDTH.MEDIUM,
                    Config.BORDER_WIDTH.FOCUSED,
                    _controller.value,
                  ) ?? Config.BORDER_WIDTH.MEDIUM,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.inverseSurface.withOpacity(
                      Config.BLUR_OPACITY.LESS * _controller.value,
                    ),
                    blurRadius: Config.BLUR_RADIUS.MEDIUM,
                  ),
                ],
                gradient: widget.dragging
                    ? LinearGradient(
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
                      )
                    : null,
                color: widget.dragging ? null : backgroundColor,
                borderRadius: BorderRadius.circular(_radiusAnim.value),
              ),
              child: itemWidget,
              // child: Text(
              //   index.toString() +
              //       ' and ' +
              //       ROW_COUNT.toString() +
              //       ' and ' +
              //       Offset(
              //         (index % ROW_COUNT).toDouble() * CELL_WIDTH,
              //         (index ~/ ROW_COUNT).toDouble() * CELL_HEIGHT,
              //       ).toString() +
              //       ' and ' +
              //       Offset(CELL_WIDTH, CELL_HEIGHT).toString(),
              // ),
            );
          },
        ),
      ),
    );
  }
}
