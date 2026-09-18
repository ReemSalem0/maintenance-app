import 'package:flutter/material.dart';

class SelectedParkController {
  static final ValueNotifier<String?> parkId = ValueNotifier(null);
  static void select(String newParkId) {
    parkId.value = newParkId;
  }

  static void clear() {
    parkId.value = null;
  }
}
