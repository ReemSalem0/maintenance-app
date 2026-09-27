import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/maintenance_record.dart';
import 'package:maintenance_app/models/ride.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/services/pending_records_service.dart';

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
  bool _isSubmitting = false;

  MaintenanceType? _selectedType;

  String _generateLocalId() {
    return DateTime.now().microsecondsSinceEpoch.toString() +
        Random().nextInt(99999).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addMaintenanceRecord),
      ),
      body: SingleChildScrollView(
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
                onPressed: _isSubmitting ? null : _submit,
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

    setState(() {
      _isSubmitting = true;
    });

    final firestoreService = FirestoreService();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    final crewMember = await firestoreService.getCrewMember(currentUser.uid);
    if (crewMember == null) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    final newRecord = MaintenanceRecord(
      id: _generateLocalId(),
      rideId: widget.ride.id,
      crewMemberUid: crewMember.uid,
      crewMemberName: crewMember.name,
      type: _selectedType!,
      description: _descriptionController.text,
      notes: _notesController.text,
      dateTime: DateTime.now(),
    );

    final pendingService = PendingRecordsService();
    await pendingService.addPendingRecord(newRecord);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.recordAddedSuccessfully),
      ),
    );
    Navigator.pop(context);

    // Attempt an immediate sync in case we're actually online now. syncAllPending safely handles both success and failure

    PendingRecordsService().syncAllPending();
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
