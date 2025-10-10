import 'package:flutter/material.dart';
import 'package:get_storage_plus/get_storage_plus.dart';
import 'package:provider/provider.dart';

import 'package:todo/core/provider.dart';

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox.expand(
      child: Container(
        // color: colorScheme.secondaryContainer,
        child: Row(
          children: [
            Text('whats up'),
            Text('ayo'),
          ],
        ),
      ),
    );
  }
}
