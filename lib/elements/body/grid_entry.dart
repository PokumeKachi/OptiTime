import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/data_type.dart';
import 'package:todo/utils/provider.dart';

import 'package:todo/utils/config.dart' as Config;

import 'task.dart' as Task;
import 'group.dart' as Group;

class Class extends StatelessWidget {
  final int uuid;
  const Class({super.key, required this.uuid});

  Widget _buildItemWidget({required TaskItem item}) {
    if (item is SingleTask) {
      return Task.Class(item: item);
    }

    if (item is GroupTask) {
      return Group.Class(item: item);
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final item = context.watch<SyncedProvider>().getItemFromUuid(uuid);

    return _buildItemWidget(item: item);
  }
}
