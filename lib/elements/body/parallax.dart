import 'package:flutter/material.dart';
import 'package:todo/utils/config.dart' as Config;

class Class extends StatefulWidget {
  final Color baseColor;
  final List<Color> colors;
  const Class({
    super.key,
    this.baseColor = Colors.blue,
    this.colors = const [Colors.purple, Colors.pink],
  });

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Config.ANIMATION.LONG_HAUL,
  )..repeat();

  late final AnimationController baseController = AnimationController(
    vsync: this,
    duration: Config.ANIMATION.LONG,
  );

  @override
  void initState() {
    super.initState();
    baseController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    baseController.dispose();
    super.dispose();
  }

  List<Color> _animatedColors() {
    return widget.colors
        .map((c) => Color.lerp(widget.baseColor, c, baseController.value)!)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final dx = (t * 2) % 1;
        final gradientColors = [
          widget.baseColor,
          ..._animatedColors(),
          widget.baseColor,
        ];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + dx * 2, -0.5),
              end: Alignment(1 + dx * 2, 0.5),
              colors: gradientColors,
              tileMode: TileMode.repeated,
            ),
          ),
        );
      },
    );
  }
}
