import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/screens/add_crew_member_screen.dart';
import 'package:maintenance_app/screens/crew_member_detail_screen.dart';
import 'package:maintenance_app/screens/login_screen.dart';
import 'package:maintenance_app/services/auth_service.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/services/locale_controller.dart';

class CrewListScreen extends StatefulWidget {
  const CrewListScreen({super.key});

  @override
  State<CrewListScreen> createState() => _CrewListScreenState();
}

class _CrewListScreenState extends State<CrewListScreen> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.crewList),
        actions: [
          IconButton(
            onPressed: () => LocaleController.toggle(),
            icon: const Icon(Icons.language),
          ),
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.search,
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<CrewMember>>(
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
                final filteredCrew = crewMembers.where((crewMember) {
                  return crewMember.name.toLowerCase().contains(
                    _searchText.toLowerCase(),
                  );
                }).toList();

                if (filteredCrew.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.noCrew),
                  );
                }
                return ListView.builder(
                  itemCount: filteredCrew.length,
                  itemBuilder: (context, index) {
                    final crewMember = filteredCrew[index];
                    return ListTile(
                      title: Text(
                        '${AppLocalizations.of(context)!.name}: ${crewMember.name}',
                      ),
                      subtitle: Text(
                        '${AppLocalizations.of(context)!.role}: ${_roleLabel(context, crewMember.role)}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CrewMemberDetailScreen(uid: crewMember.uid),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
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
