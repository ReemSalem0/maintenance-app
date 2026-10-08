import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';

String? validateEmail(BuildContext context, String? value) {
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (value == null || value.trim().isEmpty) {
    return AppLocalizations.of(context)!.requiredField;
  }
  if (!emailRegex.hasMatch(value.trim())) {
    return AppLocalizations.of(context)!.emailValidationError;
  }
  return null;
}
