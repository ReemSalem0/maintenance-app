import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/maintenance_record.dart';
import 'package:maintenance_app/models/ride.dart';
import 'package:maintenance_app/screens/add_maintenance_record_screen.dart';
import 'package:maintenance_app/screens/update_ride_status_screen.dart';
import 'package:maintenance_app/services/locale_controller.dart';
import 'package:maintenance_app/services/maintenance_service.dart';
import 'package:maintenance_app/services/ride_service.dart';

class RideDetailScreen extends StatelessWidget {
  final String rideId;

  const RideDetailScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: RideService().getRideStream(rideId),
      builder: (context, rideSnapshot) {
        if (!rideSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final ride = rideSnapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ride.name, style: const TextStyle(fontSize: 18)),
                Text(
                  _statusLabel(context, ride.status),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateRideStatusScreen(ride: ride),
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
          body: StreamBuilder<List<MaintenanceRecord>>(
            stream: MaintenanceService().getMaintenanceRecordsForRide(ride.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  '${AppLocalizations.of(context)!.error}: ${snapshot.error}',
                );
              }
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final records = snapshot.data!;
              if (records.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noRecords),
                );
              }
              return ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return ExpansionTile(
                    title: Text(_typeLabel(context, record.type)),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(record.dateTime),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          '${AppLocalizations.of(context)!.crewMember}: ${record.crewMemberName}',
                        ),
                      ),
                      ListTile(
                        title: Text(
                          '${AppLocalizations.of(context)!.description}: ${record.description}',
                        ),
                      ),
                      if (record.notes != null && record.notes!.isNotEmpty)
                        ListTile(
                          title: Text(
                            '${AppLocalizations.of(context)!.notes}: ${record.notes}',
                          ),
                        ),
                    ],
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
                  builder: (context) => AddMaintenanceRecordScreen(ride: ride),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
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

  String _typeLabel(BuildContext context, MaintenanceType type) {
    switch (type) {
      case MaintenanceType.inspection:
        return AppLocalizations.of(context)!.typeInspection;
      case MaintenanceType.repair:
        return AppLocalizations.of(context)!.typeRepair;
      case MaintenanceType.routineMaintenance:
        return AppLocalizations.of(context)!.typeRoutineMaintenance;
      case MaintenanceType.partReplacement:
        return AppLocalizations.of(context)!.typePartReplacement;
      case MaintenanceType.other:
        return AppLocalizations.of(context)!.typeOther;
    }
  }
}
