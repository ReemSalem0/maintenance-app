import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/screens/add_crew_member_screen.dart';
import 'package:maintenance_app/services/firestore_service.dart';

class CrewListScreen extends StatelessWidget {
  const CrewListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.crewList)),
      body: StreamBuilder<List<CrewMember>>(
        stream: FirestoreService().getAllCrewMembersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              '${AppLocalizations.of(context)!.error}: ${snapshot.error}',
            );
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final crewMembers = snapshot.data!;
          if (crewMembers.isEmpty) {
            return Center(child:Text(AppLocalizations.of(context)!.noCrew));
          }
          return ListView.builder(
            itemCount: crewMembers.length,
            itemBuilder: (context, index) {
              final crewMember = crewMembers[index];
              return ListTile(
                title: Text('${AppLocalizations.of(context)!.name}: ${crewMember.name}'),
                subtitle: Text('${AppLocalizations.of(context)!.role}: ${_roleLabel(context, crewMember.role)}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCrewMemberScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
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
