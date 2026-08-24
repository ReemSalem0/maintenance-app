import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/services/locale_controller.dart';

class UpdateCrewMemberRoleScreen extends StatefulWidget {
  final CrewMember crewMember;

  const UpdateCrewMemberRoleScreen({super.key, required this.crewMember});

  @override
  State<UpdateCrewMemberRoleScreen> createState() =>
      _UpdateCrewMemberRoleScreenState();
}

class _UpdateCrewMemberRoleScreenState
    extends State<UpdateCrewMemberRoleScreen> {
  late CrewRole _selectedRole;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.crewMember.role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.updateRole),
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
                initialValue: widget.crewMember.name,
                enabled: false,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
                ),
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
      await firestoreService.updateCrewMemberRole(
        widget.crewMember.uid,
        _selectedRole,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.roleUpdatedSuccessfully),
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
