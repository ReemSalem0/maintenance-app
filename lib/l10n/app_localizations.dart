import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('he'),
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @addCrewMember.
  ///
  /// In en, this message translates to:
  /// **'Add Crew Member'**
  String get addCrewMember;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRole;

  /// No description provided for @emailValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailValidationError;

  /// No description provided for @passwordValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordValidationError;

  /// No description provided for @nameValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get nameValidationError;

  /// No description provided for @roleValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please select a role'**
  String get roleValidationError;

  /// No description provided for @crewMemberNotFound.
  ///
  /// In en, this message translates to:
  /// **'Crew Member not found'**
  String get crewMemberNotFound;

  /// No description provided for @welcomeActive.
  ///
  /// In en, this message translates to:
  /// **'Welcome, you are now activated'**
  String get welcomeActive;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// No description provided for @crewMemberAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Crew Member added successfully!'**
  String get crewMemberAddedSuccessfully;

  /// No description provided for @roleAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get roleAdministrator;

  /// No description provided for @roleManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get roleManager;

  /// No description provided for @roleTechnician.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get roleTechnician;

  /// No description provided for @roleInspector.
  ///
  /// In en, this message translates to:
  /// **'Inspector'**
  String get roleInspector;

  /// No description provided for @addRide.
  ///
  /// In en, this message translates to:
  /// **'Add Ride'**
  String get addRide;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please write a description'**
  String get descriptionValidationError;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Status'**
  String get selectStatus;

  /// No description provided for @statusValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please select status'**
  String get statusValidationError;

  /// No description provided for @statusOperational.
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get statusOperational;

  /// No description provided for @statusUnderMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance'**
  String get statusUnderMaintenance;

  /// No description provided for @statusOutOfService.
  ///
  /// In en, this message translates to:
  /// **'Out of Service'**
  String get statusOutOfService;

  /// No description provided for @rideAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Ride added successsfully'**
  String get rideAddedSuccessfully;

  /// No description provided for @manageRides.
  ///
  /// In en, this message translates to:
  /// **'Manage Rides'**
  String get manageRides;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @rideList.
  ///
  /// In en, this message translates to:
  /// **'Ride List'**
  String get rideList;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @noRides.
  ///
  /// In en, this message translates to:
  /// **'No rides yet.'**
  String get noRides;

  /// No description provided for @crewList.
  ///
  /// In en, this message translates to:
  /// **'Crew Members List'**
  String get crewList;

  /// No description provided for @noCrew.
  ///
  /// In en, this message translates to:
  /// **'No crew Members yet.'**
  String get noCrew;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'he':
      return AppLocalizationsHe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
