import 'package:flutter/material.dart';

import 'core/home_page.dart' as HomePage;
import 'core/layout.dart' as Layout;
import 'config.dart' as Config;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.title,
      theme: ThemeData(colorScheme: Config.colorScheme),
      home: const SafeArea(child: Layout.Class()),
    );
  }
}

void main() {
  runApp(const App());
}
