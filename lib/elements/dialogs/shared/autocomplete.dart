import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:todo/utils/provider.dart';
import 'package:todo/utils/config.dart' as Config;

class Class extends StatefulWidget {
  const Class({super.key, required this.controller, required this.getOptions});

  final TextEditingController controller;
  final List<String> Function() getOptions;

  @override
  _ClassState createState() => _ClassState();
}

class _ClassState extends State<Class> {
  late final _focusNode = FocusNode();
  late final _layerLink = LayerLink();
  late final _textFieldKey = GlobalKey();

  OverlayEntry? _overlayEntry;

  List<String> matchingOptions = [];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isFocused = _focusNode.hasFocus;
        final colorScheme = Theme.of(context).colorScheme;
        return CompositedTransformTarget(
          key: _textFieldKey,
          link: _layerLink,
          child: AnimatedContainer(
            duration: Config.ANIMATION.SHORT,
            curve: Curves.easeInOut,
            padding: EdgeInsets.only(top: Config.CORNER.ROUNDEST / 2),
            decoration: BoxDecoration(
              color: isFocused
                  ? colorScheme.surfaceBright
                  : colorScheme.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Config.CORNER.ROUNDEST),
                bottom: (isFocused && matchingOptions.isNotEmpty)
                    ? Radius.circular(Config.CORNER.SHARPEST)
                    : Radius.circular(Config.CORNER.ROUNDEST),
              ),
              border: Border.all(
                color: isFocused ? colorScheme.primary : colorScheme.outline,
                width: isFocused
                    ? Config.BORDER_WIDTH.FOCUSED
                    : Config.BORDER_WIDTH.MEDIUM,
              ),
            ),
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              style: TextStyle(fontSize: Config.FONT_SIZE.MEDIUM),
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
      setState(() {});
      _overlayEntry?.markNeedsBuild();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_overlayEntry != null) return;

      _overlayEntry = OverlayEntry(
        builder: (context) {
          final renderBox =
              _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
          final size = renderBox?.size ?? Size.zero;

          final colorScheme = Theme.of(context).colorScheme;

          final shouldShowOptions =
              (_focusNode.hasFocus && matchingOptions.isNotEmpty);

          return Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height - Config.BORDER_WIDTH.FOCUSED),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.transparent,
                elevation: Config.ELEVATION.MEDIUM,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: Config.BORDER_WIDTH.FOCUSED,
                    color: colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Config.CORNER.SHARPEST),
                    bottom: Radius.circular(Config.CORNER.ROUNDEST),
                  ),
                ),
                child: AnimatedSize(
                  duration: Config.ANIMATION.SHORT,
                  curve: Curves.easeOutExpo,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: shouldShowOptions ? 350 : 0,
                    ),
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
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        child: ListView(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            for (final option in matchingOptions)
                              TextButton(
                                onPressed: () => _onOptionPressed(option),
                                style: TextButton.styleFrom(
                                  minimumSize: Size(double.infinity, 0),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Config
                                        .SOME_RANDOM_AHH_TEXT_FIELD_PADDING_SHIT,
                                    vertical: Config.ITEM_PADDING.MEDIUM,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: Config.FONT_SIZE.MEDIUM,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void _onTextChanged() {
    final newMatchingOptions = widget
        .getOptions()
        .where(
          (option) => option.toLowerCase().contains(
            widget.controller.text.toLowerCase(),
          ),
        )
        .toList();

    if (listEquals(matchingOptions, newMatchingOptions)) {
      return;
    }

    setState(() {
      matchingOptions = newMatchingOptions;
    });

    _overlayEntry?.markNeedsBuild();
  }

  void _onOptionPressed(final String name) {
    setState(() {
      widget.controller.text = name;
    });
    _focusNode.unfocus();
  }
}
