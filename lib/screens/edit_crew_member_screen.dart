import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/models/park.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/services/park_service.dart';
import 'package:maintenance_app/utils/error_messages.dart';
import 'package:maintenance_app/utils/text_direction.dart';

class EditCrewMemberScreen extends StatefulWidget {
  final CrewMember crewMember;

  const EditCrewMemberScreen({super.key, required this.crewMember});

  @override
  State<EditCrewMemberScreen> createState() => _EditCrewMemberScreenState();
}

class _EditCrewMemberScreenState extends State<EditCrewMemberScreen> {
  late CrewRole _selectedRole;
  late TextEditingController _nameController;
  late String? _selectedParkId;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.crewMember.role;
    _nameController = TextEditingController(text: widget.crewMember.name);
    _selectedParkId = widget.crewMember.parkId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.updateCrewMember),
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
                  controller: _nameController,
                  textDirection: textDirectionFor(_nameController.text),
                  textAlign: TextAlign.right,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                if (_selectedRole == CrewRole.manager ||
                    _selectedRole == CrewRole.technician)
                  StreamBuilder<List<Park>>(
                    stream: ParkService().getAllParksStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          '${AppLocalizations.of(context)!.error}: ${friendlyError(context, snapshot.error!)}',
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
                        initialValue: _selectedParkId,
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
                            )!.requiredField;
                          }
                          return null;
                        },
                      );
                    },
                  ),
                DropdownButtonFormField(
                  initialValue: _selectedRole,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.selectRole,
                  ),
                  items: CrewRole.values.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(_roleLabel(context, role)),
                    );
                  }).toList(),
                  onChanged: (newRole) {
                    setState(() {
                      _selectedRole = newRole!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return AppLocalizations.of(context)!.requiredField;
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
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    final firestoreService = FirestoreService();
    final String? parkIdToSave =
        (_selectedRole == CrewRole.manager ||
            _selectedRole == CrewRole.technician)
        ? _selectedParkId
        : null;

    try {
      await firestoreService.updateCrewMember(
        widget.crewMember.uid,
        _nameController.text,
        _selectedRole,
        parkIdToSave,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.crewMemberInfoUpdatedSuccessfully,
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyError(context, e))));
    }
  }

  String _roleLabel(BuildContext context, CrewRole role) {
    switch (role) {
      case CrewRole.administrator:
        return AppLocalizations.of(context)!.roleAdministrator;
      case CrewRole.manager:
        return AppLocalizations.of(context)!.roleManager;
      case CrewRole.technician:
        return AppLocalizations.of(context)!.roleTechnician;
      case CrewRole.inspector:
        return AppLocalizations.of(context)!.roleInspector;
    }
  }
}
