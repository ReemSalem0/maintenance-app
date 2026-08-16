// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Log in';

  @override
  String get addCrewMember => 'Add Crew Member';

  @override
  String get name => 'Name';

  @override
  String get selectRole => 'Select Role';

  @override
  String get emailValidationError => 'Please enter a valid email address';

  @override
  String get passwordValidationError => 'Please enter your password';

  @override
  String get nameValidationError => 'Please enter a name';

  @override
  String get roleValidationError => 'Please select a role';

  @override
  String get crewMemberNotFound => 'Crew Member not found';

  @override
  String get welcomeActive => 'Welcome, you are now activated';

  @override
  String get loginSuccessful => 'Login successful!';

  @override
  String get crewMemberAddedSuccessfully => 'Crew Member added successfully!';

  @override
  String get roleAdministrator => 'Administrator';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleTechnician => 'Technician';

  @override
  String get roleInspector => 'Inspector';

  @override
  String get addRide => 'Add Ride';

  @override
  String get description => 'Description';

  @override
  String get descriptionValidationError => 'Please write a description';

  @override
  String get location => 'Location';

  @override
  String get notes => 'Notes';

  @override
  String get selectStatus => 'Select Status';

  @override
  String get statusValidationError => 'Please select status';

  @override
  String get statusOperational => 'Operational';

  @override
  String get statusUnderMaintenance => 'Under Maintenance';

  @override
  String get statusOutOfService => 'Out of Service';

  @override
  String get rideAddedSuccessfully => 'Ride added successsfully';

  @override
  String get manageRides => 'Manage Rides';
}
