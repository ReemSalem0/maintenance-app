import 'package:flutter/material.dart';

class LocaleController {
  static final ValueNotifier<Locale> locale = ValueNotifier(const Locale('en'));

  static void toggle() {
    locale.value = locale.value.languageCode == 'en'
        ? const Locale('he')
        : const Locale('en');
  }
}
