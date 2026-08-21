import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/ride.dart';
import 'package:maintenance_app/services/locale_controller.dart';
import 'package:maintenance_app/services/ride_service.dart';


class UpdateRideStatusScreen extends StatefulWidget {
  final Ride ride;

  const UpdateRideStatusScreen({super.key, required this.ride});

  @override
  State<UpdateRideStatusScreen> createState() => _UpdateRideStatusScreenState();
}

class _UpdateRideStatusScreenState extends State<UpdateRideStatusScreen> {
  late RideStatus _selectedStatus;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.ride.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.updateStatus),
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
                initialValue: widget.ride.name,
                enabled: false,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
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
                    _selectedStatus = newStatus!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context)!.statusValidationError;
                  }
                  return null;
                },
              ),
               ElevatedButton(
                onPressed: _submit,
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if(!_formkey.currentState!.validate()) {
      return;
    }

    final rideService = RideService();

    try {
      await rideService.updateRideStatus(widget.ride.id, _selectedStatus);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.updatedSuccessfully),
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
