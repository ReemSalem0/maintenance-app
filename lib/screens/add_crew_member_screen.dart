import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/park.dart';
import 'package:maintenance_app/services/auth_service.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/services/locale_controller.dart';
import 'package:maintenance_app/services/park_service.dart';

class AddCrewMemberScreen extends StatefulWidget {
  const AddCrewMemberScreen({super.key});

  @override
  State<AddCrewMemberScreen> createState() => _AddCrewMemberScreenState();
}

class _AddCrewMemberScreenState extends State<AddCrewMemberScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String? _selectedParkId;

  CrewRole? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addCrewMember),
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
              if (_selectedRole == CrewRole.manager ||
                  _selectedRole == CrewRole.technician)
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
                          )!.parkValidationError;
                        }
                        return null;
                      },
                    );
                  },
                ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                ),
                validator: (value) {
                  if (value == null ||
                      !value.trim().contains('@') ||
                      value.trim().isEmpty) {
                    return AppLocalizations.of(context)!.emailValidationError;
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<CrewRole>(
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
                    _selectedRole = newRole;
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
                child: Text(AppLocalizations.of(context)!.addCrewMember),
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<void> _submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    final authService = AuthService();
    final firestoreService = FirestoreService();
    final String? parkIdToSave =
        (_selectedRole == CrewRole.manager ||
            _selectedRole == CrewRole.technician)
        ? _selectedParkId
        : null;

    try {
      await firestoreService.addCrewMember(
        authService,
        _nameController.text,
        _emailController.text,
        _selectedRole!,
        parkIdToSave,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.crewMemberAddedSuccessfully,
          ),
        ),
      );
      _nameController.text = '';
      _emailController.text = '';
      setState(() {
        _selectedRole = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
