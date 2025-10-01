import 'package:flutter/material.dart';

import 'core/home_page.dart' as HomePage;
import 'config.dart' as Config;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.title,
      theme: ThemeData(colorScheme: Config.colorScheme),
      home: const SafeArea(child: HomePage.Class(title: Config.title)),

      // onGenerateRoute: (settings) {
      //   switch (settings.name) {
      //     case '/':
      //       return MaterialPageRoute(builder: (_) => const HomePage());
      //     case '/about':
      //       return MaterialPageRoute(builder: (_) => const AboutPage());
      //     default:
      //       return MaterialPageRoute(builder: (_) => const NotFoundPage());
      //   }
      // },
    );
  }
}

void main() {
  runApp(const App());
}
