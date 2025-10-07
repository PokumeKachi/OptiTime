import 'package:flutter/material.dart';

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Row(
        children: [
          Text('yea'),
          Text('yea'),
        ],
      ),
    );
  }
}
