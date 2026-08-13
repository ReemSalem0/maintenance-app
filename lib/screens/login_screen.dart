import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/screens/add_crew_member_screen.dart';
import 'package:maintenance_app/services/auth_service.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/models/crew_member.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.welcomeBack)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
                validator: (value) {
                  if (value == null ||
                      !value.trim().contains('@') ||
                      value.trim().isEmpty) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              ElevatedButton(onPressed: _login, child: Text(AppLocalizations.of(context)!.login)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formkey.currentState!.validate()) {
      return; // if invalid, stop!
    }

    final authService = AuthService();
    final firestoreService = FirestoreService();

    try {
      final userCredential = await authService.signIn(
        _emailController.text,
        _passwordController.text,
      );
      final crewMember = await firestoreService.getCrewMember(
        userCredential.user!.uid,
      );

      if (!mounted) return;

      if (crewMember == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Crew Member not found')));
        return;
      }

      if (!crewMember.accountActivated) {
        firestoreService.markAccountActivated(crewMember.uid);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Welcome, you are now activated!')),
        );
      }

      if (crewMember.role == CrewRole.administrator) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AddCrewMemberScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('login successful!')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
