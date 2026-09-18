import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/models/park.dart';
import 'package:maintenance_app/screens/dashboard_screen.dart';
import 'package:maintenance_app/screens/login_screen.dart';
import 'package:maintenance_app/services/auth_service.dart';
import 'package:maintenance_app/services/park_service.dart';
import 'package:maintenance_app/services/selected_park_controller.dart';
import 'package:maintenance_app/widgets/dashboard_card.dart';

class ParkSelectionScreen extends StatelessWidget {
  final CrewMember crewMember;

  const ParkSelectionScreen({super.key, required this.crewMember});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectPark),
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
      body: StreamBuilder<List<Park>>(
        stream: ParkService().getAllParksStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              '${AppLocalizations.of(context)!.error}: ${snapshot.error}',
            );
          }
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 56,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final parks = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: parks.map((park) {
                return DashboardCard(
                  icon: Icons.park_outlined,
                  label: park.name,
                  accentColor: const Color(0xFF1E3A5F),
                  onTap: () {
                    SelectedParkController.select(park.id);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DashboardScreen(crewMember: crewMember),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
