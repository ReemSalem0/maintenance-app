import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:maintenance_app/screens/login_screen.dart';
import 'package:maintenance_app/services/locale_controller.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LocaleController.locale,
      builder: (context, locale, child) {
        return MaterialApp(
          title: 'Maintenance App',
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('he')],
          home: const LoginScreen(),
        );
      },
    );
  }
}
