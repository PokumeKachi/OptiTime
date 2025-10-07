import 'package:flutter/material.dart';

<<<<<<< HEAD
import 'core/home_page.dart' as HomePage;
=======
import 'core/layout.dart' as Layout;
>>>>>>> resign-temp
import 'config.dart' as Config;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.title,
      theme: ThemeData(colorScheme: Config.colorScheme),
<<<<<<< HEAD
      home: const SafeArea(child: Layout.Class()),
>>>>>>> resign-temp
    );
  }
}

void main() {
  runApp(const App());
}
