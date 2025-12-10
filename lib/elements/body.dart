import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/data_type.dart';

import 'package:todo/utils/config.dart' as Config;
import 'body/grid_view.dart' as GridView;

class Class extends StatelessWidget {
  const Class({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('body rebuild');

    return OrientationBuilder(
      builder: (context, orientation) {
        final SIZE = MediaQuery.of(context).size;
        final HEIGHT = SIZE.height;
        final WIDTH = SIZE.width;
        final PORTRAIT = HEIGHT > WIDTH;

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: PORTRAIT ? HEIGHT * Config.NAV_BAR_RATIO : 0,
              right: !PORTRAIT ? WIDTH * Config.NAV_BAR_RATIO : 0,
            ),
            child: GridView.Class(),
          ),
        );
      },
    );
  }
}
