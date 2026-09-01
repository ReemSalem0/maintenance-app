// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get welcomeBack => 'ברוך שובך!';

  @override
  String get email => 'אימייל';

  @override
  String get password => 'סיסמה';

  @override
  String get login => 'התחבר';

  @override
  String get addCrewMember => 'הוסף איש צוות';

  @override
  String get name => 'שם';

  @override
  String get selectRole => 'בחר תפקיד';

  @override
  String get emailValidationError => 'אנא הזן כתובת אימייל תקינה';

  @override
  String get passwordValidationError => 'אנא הזן סיסמה';

  @override
  String get nameValidationError => 'אנא הזן שם';

  @override
  String get roleValidationError => 'אנא בחר תפקיד';

  @override
  String get crewMemberNotFound => 'איש צוות לא נמצא';

  @override
  String get welcomeActive => 'ברוך הבא, החשבון שלך פעיל';

  @override
  String get loginSuccessful => 'ההתחברות בוצעה בהצלחה';

  @override
  String get crewMemberAddedSuccessfully => 'איש הצוות נוסף בהצלחה';

  @override
  String get roleAdministrator => 'מנהל מערכת';

  @override
  String get roleManager => 'מנהל';

  @override
  String get roleTechnician => 'טכנאי';

  @override
  String get roleInspector => 'מפקח';

  @override
  String get addRide => 'הוסף מתקן';

  @override
  String get description => 'תאור';

  @override
  String get descriptionValidationError => 'אנא הזן תאור';

  @override
  String get location => 'מיקום';

  @override
  String get notes => 'הערות';

  @override
  String get selectStatus => 'בחר מצב';

  @override
  String get statusValidationError => 'אנא בחר מצב';

  @override
  String get statusOperational => 'פעיל';

  @override
  String get statusUnderMaintenance => 'בטיפול ותחזוקה';

  @override
  String get statusOutOfService => 'מקולקל';

  @override
  String get rideAddedSuccessfully => 'מתקן נוסף בהצלחה';

  @override
  String get manageRides => 'ניהול מתקנים';

  @override
  String get dashboard => 'לוח בקרה ראשי';

  @override
  String get rideList => 'רשימת מתקנים';

  @override
  String get error => 'שגיאה';

  @override
  String get noRides => 'אין מתקנים';

  @override
  String get crewList => 'רשימת אנשי הצוות';

  @override
  String get noCrew => 'אין אנשי צוות';

  @override
  String get noRecords => 'אין נתונים';

  @override
  String get typeInspection => 'בדיקה';

  @override
  String get typeRepair => 'תיקון';

  @override
  String get typeRoutineMaintenance => 'תחזוקה שיגרתית';

  @override
  String get typePartReplacement => 'החלפת חלק';

  @override
  String get typeOther => 'אחר';

  @override
  String get addMaintenanceRecord => 'הוספת תעוד תחזוקה';

  @override
  String get selectType => 'בחר סוג תחזוקה';

  @override
  String get typeValidationError => 'אנא בחר סוג תחזוקה';

  @override
  String get save => 'שמור';

  @override
  String get recordAddedSuccessfully => 'תחזוקה תועדה בהצלחה';

  @override
  String get crewMember => 'איש צוות';

  @override
  String get status => 'מצב';

  @override
  String get role => 'תפקיד';

  @override
  String get sortByName => 'מיון לפי שם';

  @override
  String get sortByStatus => 'מיון לפי מצב';

  @override
  String get updateStatus => 'עדכון מצב';

  @override
  String get statusUpdatedSuccessfully => 'מצב עודכן בהצלחה';

  @override
  String get updateRole => 'עדכון תפקיד';

  @override
  String get roleUpdatedSuccessfully => 'תפקיד עודכן בהצלחה';

  @override
  String get search => 'חיפוש';

  @override
  String get startDate => 'מתאריך';

  @override
  String get endDate => 'עד תאריך';

  @override
  String get filterByDate => 'סנן לפי תאריך';
}
