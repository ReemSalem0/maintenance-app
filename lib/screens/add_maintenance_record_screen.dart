import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/maintenance_record.dart';
import 'package:maintenance_app/models/ride.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/services/locale_controller.dart';
import 'package:maintenance_app/services/maintenance_service.dart';

class AddMaintenanceRecordScreen extends StatefulWidget {
  final Ride ride;

  const AddMaintenanceRecordScreen({super.key, required this.ride});

  @override
  State<AddMaintenanceRecordScreen> createState() =>
      _AddMaintenanceRecordScreenState();
}

class _AddMaintenanceRecordScreenState
    extends State<AddMaintenanceRecordScreen> {
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  MaintenanceType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addMaintenanceRecord),
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
              DropdownButtonFormField<MaintenanceType>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.selectType,
                ),
                items: MaintenanceType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_typeLabel(context, type)),
                  );
                }).toList(),
                onChanged: (newType) {
                  setState(() {
                    _selectedType = newType;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context)!.typeValidationError;
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
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.notes,
                ),
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
    if (!_formkey.currentState!.validate()) {
      return;
    }

    final firestoreService = FirestoreService();
    final maintenanceService = MaintenanceService();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final crewMember = await firestoreService.getCrewMember(currentUser.uid);
    if (crewMember == null) {
      return;
    }

    final newRecord = MaintenanceRecord(
      id: '',
      rideId: widget.ride.id,
      crewMemberUid: crewMember.uid,
      crewMemberName: crewMember.name,
      type: _selectedType!,
      description: _descriptionController.text,
      notes: _notesController.text,
      dateTime: DateTime.now(),
    );

    try {
      await maintenanceService.addMaintenanceRecord(newRecord);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.recordAddedSuccessfully),
        ),
      );
      Navigator.pop(context); //return the detail screen after saving
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
