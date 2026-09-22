import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/park.dart';
import 'package:maintenance_app/models/ride.dart';
import 'package:maintenance_app/services/park_service.dart';
import 'package:maintenance_app/services/ride_service.dart';

class EditRideScreen extends StatefulWidget {
  final Ride ride;

  const EditRideScreen({super.key, required this.ride});

  @override
  State<EditRideScreen> createState() => _EditRideScreen();
}

class _EditRideScreen extends State<EditRideScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  final _formkey = GlobalKey<FormState>();
  String? _selectedParkId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ride.name);
    _descriptionController = TextEditingController(
      text: widget.ride.description,
    );
    _locationController = TextEditingController(text: widget.ride.location);
    _notesController = TextEditingController(text: widget.ride.notes);
    _selectedParkId = widget.ride.parkId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.ride.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)!.nameValidationError;
                  }
                  return null;
                },
              ),
              StreamBuilder<List<Park>>(
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
                  return DropdownButtonFormField<String>(
                    initialValue: widget.ride.parkId,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.selectPark,
                    ),
                    items: parks.map((park) {
                      return DropdownMenuItem(
                        value: park.id,
                        child: Text(park.name),
                      );
                    }).toList(),
                    onChanged: (newParkId) {
                      setState(() {
                        _selectedParkId = newParkId;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return AppLocalizations.of(
                          context,
                        )!.parkValidationError;
                      }
                      return null;
                    },
                  );
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(
                      context,
                    )!.descriptionValidationError;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.location,
                ),
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.notes,
                ),
              ),

              ElevatedButton(
                onPressed: _submit,
                child: Text(AppLocalizations.of(context)!.updateRide),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    final rideService = RideService();
    final newRide = Ride(
      id: widget.ride.id,
      name: _nameController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      status: widget.ride.status,
      notes: _notesController.text,
      createdAt: widget.ride.createdAt,
      parkId: _selectedParkId!,
    );

    try {
      await rideService.updateRide(newRide);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.rideUpdatedSuccessfully),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
