import 'package:flutter/material.dart';
import 'package:todo/utils/config.dart' as Config;

class Class extends StatefulWidget {
  final TextEditingController controller;
  const Class({super.key, required this.controller});

  static const FOCUSED_BORDER_WIDTH = 2.0;

  @override
  _ClassState createState() => _ClassState();
}

class _ClassState extends State<Class> {
  late final _focusNode = FocusNode();
  late final _layerLink = LayerLink();

  late final _overlayEntry;
  late final _textFieldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return CompositedTransformTarget(
          key: _textFieldKey,
          link: _layerLink,
          child: AnimatedContainer(
            duration: Config.ANIMATION.MEDIUM,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: _focusNode.hasFocus
                  ? colorScheme.surfaceBright
                  : colorScheme.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Config.CORNER.MAX),
                bottom: _focusNode.hasFocus
                    ? Radius.circular(Config.CORNER.MIN)
                    : Radius.circular(Config.CORNER.MAX),
              ),

              // borderRadius: BorderRadius.circular(
              //   _focusNode.hasFocus ? Config.CORNER.MAX : Config.CORNER.MIN,
              // ),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                width: Class.FOCUSED_BORDER_WIDTH,
              ),
            ),
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Group',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Config.SOME_RANDOM_AHH_TEXT_FIELD_PADDING_SHIT,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = _textFieldKey.currentContext?.size;

      if (size == null) {
        return;
      }

      print(size.width);
      print(size.height);

      _overlayEntry = OverlayEntry(
        builder: (_) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height),
            child: Material(
              elevation: Config.ELEVATION.LOW,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: Class.FOCUSED_BORDER_WIDTH),
                // borderRadius: border.borderRadius,
              ),
              clipBehavior: Clip.antiAlias,

              child: Offstage(
                offstage: (!_focusNode.hasFocus),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: const [Text('help me')],
                ),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_overlayEntry);
    });

    _focusNode.addListener(
      () => setState(() {
        _overlayEntry.markNeedsBuild();
      }),
    );
  }

  void _onTextChanged() {}
}
