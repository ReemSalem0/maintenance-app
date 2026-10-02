import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/screens/login_screen.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/utils/role_router.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.hasError) {
          return Text(
            '${AppLocalizations.of(context)!.error}: ${authSnapshot.error}',
          );
        }
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!authSnapshot.hasData) {
          return const LoginScreen();
        } else {
          final user = authSnapshot.data!;
          return FutureBuilder<CrewMember?>(
            future: FirestoreService().getCrewMember(user.uid),
            builder: (context, crewSnapshot) {
              if (crewSnapshot.hasError) {
                return Text(
                  '${AppLocalizations.of(context)!.error}: ${crewSnapshot.error}',
                );
              }
              if (crewSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              if (!crewSnapshot.hasData) {
                FirebaseAuth.instance.signOut();
                return const LoginScreen();
              } else {
                final crewMember = crewSnapshot.data!;
                return homeScreenForRole(crewMember);
              }
            },
          );
        }
      },
    );
  }
}
