import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/models/park.dart';
import 'package:maintenance_app/screens/crew_list_screen.dart';
import 'package:maintenance_app/screens/crew_member_detail_screen.dart';
import 'package:maintenance_app/screens/login_screen.dart';
import 'package:maintenance_app/screens/park_selection_screen.dart';
import 'package:maintenance_app/screens/ride_list_screen.dart';
import 'package:maintenance_app/services/auth_service.dart';
import 'package:maintenance_app/services/park_service.dart';
import 'package:maintenance_app/services/selected_park_controller.dart';
import 'package:maintenance_app/utils/error_messages.dart';
import 'package:maintenance_app/widgets/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  final CrewMember crewMember;

  const DashboardScreen({super.key, required this.crewMember});

  @override
  Widget build(BuildContext context) {
    final String? effectiveParkId =
        (crewMember.role == CrewRole.administrator ||
            crewMember.role == CrewRole.inspector)
        ? SelectedParkController.parkId.value
        : crewMember.parkId;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: StreamBuilder<Park>(
          stream: ParkService().getParkStream(effectiveParkId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                '${AppLocalizations.of(context)!.error}: ${friendlyError(context, snapshot.error!)}',
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final park = snapshot.data!;
            return Text(park.name);
          },
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              childAspectRatio: 1.0,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            children: [
              DashboardCard(
                icon: Icons.attractions_outlined,
                label: AppLocalizations.of(context)!.rideList,
                accentColor: const Color(0xFF1E3A5F),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RideListScreen(crewMember: crewMember),
                    ),
                  );
                },
              ),
              if (crewMember.role == CrewRole.administrator)
                DashboardCard(
                  icon: Icons.badge_outlined,
                  label: AppLocalizations.of(context)!.crewList,
                  accentColor: const Color(0xFFE8A33D),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CrewListScreen(crewMember: crewMember),
                      ),
                    );
                  },
                ),
              if (crewMember.role == CrewRole.administrator ||
                  crewMember.role == CrewRole.inspector)
                DashboardCard(
                  icon: Icons.swap_horiz,
                  label: AppLocalizations.of(context)!.switchParks,
                  accentColor: const Color.fromARGB(255, 223, 89, 89),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ParkSelectionScreen(crewMember: crewMember),
                      ),
                    );
                  },
                ),
              DashboardCard(
                icon: Icons.info_outline,
                label: AppLocalizations.of(context)!.myDetails,
                accentColor: const Color(0xFF6BBE9E),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CrewMemberDetailScreen(
                        uid: crewMember.uid,
                        canEditRole: false,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
