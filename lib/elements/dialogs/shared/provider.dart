import 'package:flutter/material.dart';

class KeyEventProvider extends ChangeNotifier {
  RawKeyEvent? lastEvent;
  void fire(RawKeyEvent event) {
    lastEvent = event;
    notifyListeners();
  }
}
