import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/config.dart' as Config;

class Class extends StatefulWidget {
  const Class({super.key, required this.controller, required this.getOptions});

  final TextEditingController controller;
  final List<String> Function() getOptions;

  static const FOCUSED_BORDER_WIDTH = 2.0;

  @override
  _ClassState createState() => _ClassState();
}

class _ClassState extends State<Class> {
  late final _focusNode = FocusNode();
  late final _layerLink = LayerLink();
  late final _textFieldKey = GlobalKey();

  late final _overlayEntry;

  List<String> matchingOptions = [];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldShowOptions =
            (_focusNode.hasFocus && matchingOptions.isNotEmpty);
        return CompositedTransformTarget(
          key: _textFieldKey,
          link: _layerLink,
          child: AnimatedContainer(
            duration: Config.ANIMATION.MEDIUM,
            curve: Curves.easeInOut,
            padding: EdgeInsets.only(top: Config.CORNER.MAX / 2),
            decoration: BoxDecoration(
              color: shouldShowOptions
                  ? colorScheme.surfaceBright
                  : colorScheme.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Config.CORNER.MAX),
                bottom: shouldShowOptions
                    ? Radius.circular(Config.CORNER.MIN)
                    : Radius.circular(Config.CORNER.MAX),
              ),
              border: Border.all(
                color: shouldShowOptions
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
                floatingLabelBehavior: FloatingLabelBehavior.auto,
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

    _focusNode.addListener(() {
      _onTextChanged();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = _textFieldKey.currentContext?.size;

      if (size == null) {
        return;
      }

      _overlayEntry = OverlayEntry(
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;

          final shouldShowOptions =
              (_focusNode.hasFocus && matchingOptions.isNotEmpty);

          return Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height - Class.FOCUSED_BORDER_WIDTH),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.transparent,
                elevation: Config.ELEVATION.LOW,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: Class.FOCUSED_BORDER_WIDTH,
                    color: colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Config.CORNER.MIN),
                    bottom: Radius.circular(Config.CORNER.MAX),
                  ),
                ),
                child: AnimatedContainer(
                  duration: Config.ANIMATION.SHORT,
                  curve: Curves.easeOutExpo,
                  height: shouldShowOptions ? 150 : 0,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.surfaceBright,
                          colorScheme.surfaceDim,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final option in matchingOptions) ...[
                          TextButton(
                            onPressed: () => _onOptionPressed(option),
                            style: TextButton.styleFrom(
                              minimumSize: Size(double.infinity, 0),
                              padding: EdgeInsets.symmetric(
                                horizontal: Config
                                    .SOME_RANDOM_AHH_TEXT_FIELD_PADDING_SHIT,
                                vertical: Config.ITEM_PADDING.SMALL,
                              ),
                              alignment: Alignment.centerLeft,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: Text(option),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
      Overlay.of(context).insert(_overlayEntry);
    });
  }

  void _onTextChanged() {
    setState(() {
      matchingOptions = widget
          .getOptions()
          .where(
            (option) => option.toLowerCase().contains(
              widget.controller.text.toLowerCase(),
            ),
          )
          .toList();
    });

    _overlayEntry.markNeedsBuild();
  }

  void _onOptionPressed(final String name) {
    setState(() {
      widget.controller.text = name;
    });
  }
}
