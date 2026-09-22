import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/services/firestore_service.dart';

class EditCrewMemberScreen extends StatefulWidget {
  final CrewMember crewMember;

  const EditCrewMemberScreen({super.key, required this.crewMember});

  @override
  State<EditCrewMemberScreen> createState() => _EditCrewMemberScreenState();
}

class _EditCrewMemberScreenState extends State<EditCrewMemberScreen> {
  late CrewRole _selectedRole;
  late TextEditingController _nameController;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.crewMember.role;
    _nameController = TextEditingController(text: widget.crewMember.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.updateCrewMember),
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
                    return AppLocalizations.of(context)!.roleValidationError;
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
    if (!_formkey.currentState!.validate()) {
      return;
    }

    final firestoreService = FirestoreService();

    try {
      await firestoreService.updateCrewMember(
        widget.crewMember.uid,
        _nameController.text,
        _selectedRole,
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
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
