import 'package:flutter/material.dart';

TextDirection textDirectionFor(String text) {
  final match = RegExp(r'[A-Za-z\u0590-\u05FF]').firstMatch(text);

  if (match == null) {
    return TextDirection.rtl;
  }
  final firstLetter = match.group(0)!;

  if (RegExp(r'[A-Za-z]').hasMatch(firstLetter)) {
    return TextDirection.ltr;
  }

  return TextDirection.rtl;
}
