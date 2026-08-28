import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/screens/add_ride_screen.dart';
import 'package:maintenance_app/services/locale_controller.dart';
import 'package:maintenance_app/services/ride_service.dart';
import 'package:maintenance_app/models/ride.dart';
import 'package:maintenance_app/screens/ride_detail_screen.dart';

enum RideSortOption { name, status }

class RideListScreen extends StatefulWidget {
  const RideListScreen({super.key});

  @override
  State<RideListScreen> createState() => _RideListScreenState();
}

class _RideListScreenState extends State<RideListScreen> {
  RideSortOption _sortOption = RideSortOption.name;
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.rideList),
        actions: [
          IconButton(
            onPressed: () => LocaleController.toggle(),
            icon: const Icon(Icons.language),
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
                DropdownButton<RideSortOption>(
                  value: _sortOption,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: RideSortOption.name,
                      child: Text(AppLocalizations.of(context)!.sortByName),
                    ),
                    DropdownMenuItem(
                      value: RideSortOption.status,
                      child: Text(AppLocalizations.of(context)!.sortByStatus),
                    ),
                  ],
                  onChanged: (newOption) {
                    setState(() {
                      _sortOption = newOption!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Ride>>(
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
                if (_sortOption == RideSortOption.name) {
                  rides.sort((a, b) => a.name.compareTo(b.name));
                } else {
                  rides.sort(
                    (a, b) => _statusPriority(
                      a.status,
                    ).compareTo(_statusPriority(b.status)),
                  );
                }

                final filteredRides = rides.where((ride) {
                  return ride.name.toLowerCase().contains(
                    _searchText.toLowerCase(),
                  );
                }).toList();

                if (filteredRides.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.noRides),
                  );
                }
                return ListView.builder(
                  itemCount: filteredRides.length,
                  itemBuilder: (context, index) {
                    final ride = filteredRides[index];
                    return ListTile(
                      title: Text(
                        '${AppLocalizations.of(context)!.name}: ${ride.name}',
                      ),
                      subtitle: Text(
                        '${AppLocalizations.of(context)!.status}: ${_statusLabel(context, ride.status)}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RideDetailScreen(rideId: ride.id),
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

  int _statusPriority(RideStatus status) {
    switch (status) {
      case RideStatus.outOfService:
        return 0;
      case RideStatus.underMaintenance:
        return 1;
      case RideStatus.operational:
        return 2;
    }
  }
}
