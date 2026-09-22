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
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'updateCrew') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditCrewMemberScreen(crewMember: crewMember),
                        ),
                      );
                    } else if (value == 'deleteCrewMember') {
                      _confirmDeleteCrewMember(context, crewMember);
                    }
                  },
                  itemBuilder: (context) => [
                    if (canEditRole)
                      PopupMenuItem(
                        value: 'updateCrew',
                        child: Text(
                          AppLocalizations.of(context)!.updateCrewMember,
                        ),
                      ),
                    if (canEditRole)
                      PopupMenuItem(
                        value: 'deleteCrewMember',
                        child: Text(
                          AppLocalizations.of(context)!.deleteCrewMember,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
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

  Future<void> _confirmDeleteCrewMember(
    BuildContext context,
    CrewMember crewMember,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteCrewMember),
          content: Text(
            AppLocalizations.of(context)!.deleteCrewMemberConfirmation,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await FirestoreService().deleteCrewMember(uid);
        if (!context.mounted) return;
        Navigator.pop(context); //return to Crew Member List after deletion
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
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
