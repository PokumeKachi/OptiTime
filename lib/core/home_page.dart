import 'package:flutter/material.dart';
import 'nav_bar.dart' as NavBar;

class Class extends StatefulWidget {
  const Class({super.key, required this.title});

  final String title;

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  int _counter = 0;

  void onButtonClick() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineSmall),
            FloatingActionButton(
              onPressed: onButtonClick,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      floatingActionButton: //IconButton(onPressed: onButtonClick, icon: Icon(Icons.add)),
      FloatingActionButton(
        onPressed: onButtonClick,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: NavBar.Class(),
    );
  }
}
