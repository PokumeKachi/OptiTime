import 'package:flutter/material.dart';

class _NavButton extends StatefulWidget {
  const _NavButton({super.key, required this.icon});

  final Icon icon;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox.expand(
        child: IconButton(
          // style: ButtonStyle(
          //   backgroundColor: WidgetStateProperty.resolveWith<Color?>((
          //     Set<WidgetState> states,
          //   ) {
          //     if (states.contains(WidgetState.pressed)) {
          //       return Theme.of(context).colorScheme.primary.withOpacity(0.5);
          //     }
          //     return null; // Use the component's default.
          //   }),
          // ),
          icon: widget.icon,
          onPressed: () {},
        ),
      ),
    );
  }
}

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton.icon(onPressed: () {print("elevae");}, label: Icon(Icons.fax_rounded)),
          _NavButton(icon: Icon(Icons.home)),
          _NavButton(icon: Icon(Icons.energy_savings_leaf)),
          _NavButton(icon: Icon(Icons.add)),
          _NavButton(icon: Icon(Icons.notification_add)),
          _NavButton(icon: Icon(Icons.settings)),
          // Expanded(
          //   child: IconButton(
          //     icon: Icon(Icons.home),
          //     onPressed: () {
          //       print("hello");
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
