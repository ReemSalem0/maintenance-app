import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/screens/add_ride_screen.dart';
import 'package:maintenance_app/services/ride_service.dart';
import 'package:maintenance_app/models/ride.dart';
import 'package:maintenance_app/screens/ride_detail_screen.dart';

class RideListScreen extends StatelessWidget {
  const RideListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.rideList)),
      body: StreamBuilder<List<Ride>>(
        stream: RideService().getAllRidesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              '${AppLocalizations.of(context)!.error}: ${snapshot.error}',
            );
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final rides = snapshot.data!;
          if (rides.isEmpty) {
            return Text(AppLocalizations.of(context)!.noRides);
          }
          return ListView.builder(
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return ListTile(
                title: Text(ride.name),
                subtitle: Text(_statusLabel(context, ride.status)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RideDetailScreen(ride: ride)),);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRideScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _statusLabel(BuildContext context, RideStatus status) {
    switch (status) {
      case RideStatus.operational:
        return AppLocalizations.of(context)!.statusOperational;
      case RideStatus.underMaintenance:
        return AppLocalizations.of(context)!.statusUnderMaintenance;
      case RideStatus.outOfService:
        return AppLocalizations.of(context)!.statusOutOfService;
    }
  }
}
