import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/screens/edit_crew_member_screen.dart';
import 'package:maintenance_app/services/firestore_service.dart';

class CrewMemberDetailScreen extends StatelessWidget {
  final String uid;
  final bool canEditRole;

  const CrewMemberDetailScreen({
    super.key,
    required this.uid,
    required this.canEditRole,
  });

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
              if (canEditRole)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditCrewMemberScreen(crewMember: crewMember),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
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
