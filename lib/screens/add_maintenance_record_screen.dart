import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/attachment.dart';
import 'package:maintenance_app/models/maintenance_record.dart';
import 'package:maintenance_app/models/ride.dart';
import 'package:maintenance_app/screens/attachments_screen.dart';
import 'package:maintenance_app/services/attachment_storage.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/services/pending_records_service.dart';
import 'package:maintenance_app/utils/attachment_picker.dart';
import 'package:maintenance_app/utils/text_direction.dart';

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
  late final String _recordId = _generateLocalId();
  int _attachmentCount = 0;
  bool _saved = false;

  String _generateLocalId() {
    return DateTime.now().microsecondsSinceEpoch.toString() +
        Random().nextInt(99999).toString();
  }

  Future<void> _refreshAttachmentCount() async {
    final items = await attachmentStorage.list(
      AttachmentOwnerType.record,
      _recordId,
    );
    if (!mounted) return;
    setState(() => _attachmentCount = items.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addMaintenanceRecord),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: widget.ride.name,
                  enabled: false,
                  textDirection: textDirectionFor(widget.ride.name),
                  textAlign: TextAlign.right,
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
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  textDirection: textDirectionFor(_descriptionController.text),
                  textAlign: TextAlign.right,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.description,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _notesController,
                  textDirection: textDirectionFor(_notesController.text),
                  textAlign: TextAlign.right,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.notes,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.attach_file_outlined),
                  title: Text(AppLocalizations.of(context)!.attachFiles),
                  onTap: () async {
                    await pickAndAttach(
                      context,
                      AttachmentOwnerType.record,
                      _recordId,
                    );
                    _refreshAttachmentCount();
                  },
                ),
                if (_attachmentCount > 0)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.file_present_outlined),
                    title: Text(AppLocalizations.of(context)!.attachments),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttachmentsScreen(
                            ownerType: AttachmentOwnerType.record,
                            ownerId: _recordId,
                          ),
                        ),
                      );
                      _refreshAttachmentCount();
                    },
                  ),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ],
            ),
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
      id: _recordId,
      rideId: widget.ride.id,
      crewMemberUid: crewMember.uid,
      crewMemberName: crewMember.name,
      crewMemberRole: crewMember.role,
      type: _selectedType!,
      description: _descriptionController.text,
      notes: _notesController.text,
      dateTime: DateTime.now(),
    );

    final pendingService = PendingRecordsService();
    await pendingService.addPendingRecord(newRecord);
    _saved = true;

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

  @override
  void dispose() {
    _descriptionController.dispose();
    _notesController.dispose();
    if (!_saved) {
      attachmentStorage.deleteAllFor(AttachmentOwnerType.record, _recordId);
    }
    super.dispose();
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
