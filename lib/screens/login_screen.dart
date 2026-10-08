import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/screens/account_activated_screen.dart';
import 'package:maintenance_app/services/auth_service.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/utils/error_messages.dart';
import 'package:maintenance_app/utils/role_router.dart';
import 'package:maintenance_app/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.welcomeBack)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                  ),
                  validator: (value) => validateEmail(context, value),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(
                        context,
                      )!.requiredField;
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _login,
                  child: Text(AppLocalizations.of(context)!.login),
                ),
              ],
            ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.crewMemberNotFound),
          ),
        );
        return;
      }
      final Widget destination = homeScreenForRole(crewMember);

      if (!crewMember.accountActivated) {
        firestoreService.markAccountActivated(crewMember.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AccountActivatedScreen(destination: destination),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyError(context, e))));
    }
  }
}
