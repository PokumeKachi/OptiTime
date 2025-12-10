import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/data_type.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;

import 'task.dart' as Task;

class Class extends StatelessWidget {
  final GroupTask item;
  const Class({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final background = colorScheme.tertiaryContainer;
    final border = colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border, width: Config.BORDER_WIDTH.FOCUSED),
        borderRadius: BorderRadius.circular(Config.CORNER.ROUNDEST),
      ),
      child: Column(
        children: [
          SizedBox(height: Config.ITEM_PADDING.NARROWEST),
          Text(item.name, style: TextStyle(fontSize: Config.FONT_SIZE.BIG)),
          // SizedBox(height: Config.ITEM_PADDING.NARROWEST),
          Padding(
            padding: Config.MARGIN_PADDING.NARROW,
            child: Column(
              children: item.tasks.map((t) => Task.Class(item: t)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
