import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/ride.dart';
import 'package:maintenance_app/services/locale_controller.dart';
import 'package:maintenance_app/services/ride_service.dart';

class AddRideScreen extends StatefulWidget {
  const AddRideScreen({super.key});

  @override
  State<AddRideScreen> createState() => _AddRideScreenState();
}

class _AddRideScreenState extends State<AddRideScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  RideStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addRide),
        actions: [
          IconButton(
            onPressed: () => LocaleController.toggle(),
            icon: const Icon(Icons.language),
          ),
        ],
      ),
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
              DropdownButtonFormField<RideStatus>(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.selectStatus,
                ),
                items: RideStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_statusLabel(context, status)),
                  );
                }).toList(),
                onChanged: (newStatus) {
                  setState(() {
                    _selectedStatus = newStatus;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context)!.statusValidationError;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.notes,
                ),
              ),

              ElevatedButton(
                onPressed: _submit,
                child: Text(AppLocalizations.of(context)!.addRide),
              ),
            ],
          ),
        ),
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

  Future<void> _submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    final rideService = RideService();
    final newRide = Ride(
      id: '',
      name: _nameController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      status: _selectedStatus!,
      notes: _notesController.text,
      createdAt: DateTime.now(),
    );

    try {
      await rideService.addRide(newRide);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.rideAddedSuccessfully),
        ),
      );
      _nameController.text = '';
      _descriptionController.text = '';
      _locationController.text = '';
      _notesController.text = '';
      setState(() {
        _selectedStatus = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
