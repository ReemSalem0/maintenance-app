import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';

class AccountActivatedScreen extends StatefulWidget {
  final Widget destination;

  const AccountActivatedScreen({super.key, required this.destination});

  @override
  State<AccountActivatedScreen> createState() => _AccountActivatedScreenState();
}

class _AccountActivatedScreenState extends State<AccountActivatedScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.destination),);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64,),
            const SizedBox(height: 16,),
            Text(AppLocalizations.of(context)!.welcomeActive),
          ],
        ),
      ),
    );
  }
}