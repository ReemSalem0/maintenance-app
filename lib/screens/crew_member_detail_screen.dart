import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/screens/update_crew_member_role_screen.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/services/locale_controller.dart';

class CrewMemberDetailScreen extends StatelessWidget {
  final String uid;

  const CrewMemberDetailScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CrewMember>(
      stream: FirestoreService().getCrewMemberStream(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final crewMember = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(crewMember.name),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateCrewMemberRoleScreen(crewMember: crewMember),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () => LocaleController.toggle(),
                icon: const Icon(Icons.language),
              ),
            ],
          ),
          body: Column(
            children: [
              ListTile(
                title: Text(
                  '${AppLocalizations.of(context)!.role}: ${_roleLabel(context, crewMember.role)}',
                ),
              ),
              ListTile(
                title: Text(
                  '${AppLocalizations.of(context)!.email}: ${crewMember.email}',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _roleLabel(BuildContext context, CrewRole role) {
    switch (role) {
      case CrewRole.administrator:
        return AppLocalizations.of(context)!.roleAdministrator;
      case CrewRole.manager:
        return AppLocalizations.of(context)!.roleManager;
      case CrewRole.technician:
        return AppLocalizations.of(context)!.roleTechnician;
      case CrewRole.inspector:
        return AppLocalizations.of(context)!.roleInspector;
    }
  }
}
