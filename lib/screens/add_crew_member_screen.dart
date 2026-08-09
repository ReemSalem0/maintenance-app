import 'package:flutter/material.dart';
import 'package:maintenance_app/services/auth_service.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/models/crew_member.dart';

class AddCrewMemberScreen extends StatefulWidget {
  const AddCrewMemberScreen({super.key});

  @override
  State<AddCrewMemberScreen> createState() => _AddCrewMemberScreenState();
}

class _AddCrewMemberScreenState extends State<AddCrewMemberScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  CrewRole? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Crew Member')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null ||
                      !value.trim().contains('@') ||
                      value.trim().isEmpty) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<CrewRole>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(labelText: 'Select Role'),
                items: CrewRole.values.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role.name));
                }).toList(),
                onChanged: (newRole) {
                  setState(() {
                    _selectedRole = newRole;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a role';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Crew Member'),
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

    final authService = AuthService();
    final firestoreService = FirestoreService();

    try {
      await firestoreService.addCrewMember(
        authService,
        _nameController.text,
        _emailController.text,
        _selectedRole!,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crew Member added successfully!')),
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
