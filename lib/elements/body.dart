import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/data_types.dart';

import 'package:todo/utils/config.dart' as Config;
import 'body/items_view.dart' as ItemsView;

class Class extends StatelessWidget {
  const Class({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('body rebuild');

    return OrientationBuilder(
      builder: (context, orientation) {
        final size = MediaQuery.of(context).size;
        final height = size.height;
        final width = size.width;
        final portrait = height > width;

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: portrait ? height * Config.NAV_BAR_RATIO : 0,
              right: !portrait ? width * Config.NAV_BAR_RATIO : 0,
            ),
            child: ItemsView.Class(),
          ),
        );
      },
    );
  }
}
