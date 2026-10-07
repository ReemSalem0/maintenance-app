import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';

String friendlyError(BuildContext context, Object e) {
  final translation = AppLocalizations.of(context)!;
  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'invalid-credential' || 'wrong-password' || 'user-not-found':
        return translation.errorInvalidCredentials;
      case 'invalid-email':
        return translation.errorInvalidEmail;
      case 'email-already-in-use':
        return translation.errorEmailInUse;
      case 'too-many-requests':
        return translation.errorTooManyRequests;
      case 'network-request-failed':
        return translation.errorNetwork;
    }
  }

  if (e is FirebaseException) {
    switch (e.code) {
      case 'unavailable' || 'deadline-exceeded':
        return translation.errorNetwork;
      case 'permission-denied':
        return translation.errorPermissionDenied;
    }
  }
  debugPrint(e.toString());
  return translation.errorGeneric;
}
