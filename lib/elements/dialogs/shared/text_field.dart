import 'package:flutter/material.dart';

class FieldInfo {
  final String label;
  final TextEditingController? controller;
  final bool readOnly;
  final MouseCursor? mouseCursor;
  final Icon? suffixIcon;
  final VoidCallback? onTap;

  FieldInfo({
    required this.label,
    TextEditingController? controller,
    this.readOnly = false,
    this.mouseCursor,
    this.suffixIcon,
    this.onTap,
  }): controller = controller ?? TextEditingController();
}
