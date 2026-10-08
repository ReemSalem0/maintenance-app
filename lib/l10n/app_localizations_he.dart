// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get welcomeBack => 'כניסה למערכת';

  @override
  String get email => 'אימייל';

  @override
  String get password => 'סיסמה';

  @override
  String get login => 'התחבר';

  @override
  String get addCrewMember => 'הוספת איש צוות';

  @override
  String get name => 'שם';

  @override
  String get selectRole => 'בחר תפקיד';

  @override
  String get requiredField => 'שדה זה הוא חובה';

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
  String get addRide => 'הוספת מתקן';

  @override
  String get description => 'תאור';

  @override
  String get location => 'Location';

  @override
  String get notes => 'הערות';

  @override
  String get selectStatus => 'בחר מצב';

  @override
  String get statusOperational => 'פעיל';

  @override
  String get statusUnderMaintenance => 'בטיפול ותחזוקה';

  @override
  String get statusOutOfService => 'מושבת זמנית';

  @override
  String get statusRetired => 'מושבת';

  @override
  String get retiredRidesSection => 'מתקנים מושבתים';

  @override
  String get rideAddedSuccessfully => 'מתקן נוסף בהצלחה';

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
  String get typeRoutineMaintenance => 'תחזוקה תקופתית';

  @override
  String get typePartReplacement => 'החלפת חלק';

  @override
  String get typeOther => 'אחר';

  @override
  String get addMaintenanceRecord => 'הוספת תיעוד תחזוקה';

  @override
  String get selectType => 'בחר סוג פעולת תחזוקה';

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
  String get updateCrewMember => 'עדכון פרטי איש צוות';

  @override
  String get crewMemberInfoUpdatedSuccessfully =>
      'פרטי איש הצוות עודכנו בהצלחה';

  @override
  String get search => 'חיפוש';

  @override
  String get startDate => 'מתאריך';

  @override
  String get endDate => 'עד תאריך';

  @override
  String get filterByDate => 'סנן לפי תאריך';

  @override
  String get selectPark => 'בחר אתר';

  @override
  String get switchParks => 'מעבר בין אתרים';

  @override
  String get myDetails => 'פרטים אישיים';

  @override
  String get noParkAssigned =>
      'החשבון שלך לא משוייך לאחד האתרים, בבקשה לצור קשר עם מנהל המערכת';

  @override
  String get updateRide => 'עדכן פרטי מתקן';

  @override
  String get rideUpdatedSuccessfully => 'פרטי המתקן עודכנו בהצלחה';

  @override
  String get editRide => 'עריכת פרטי מתקן';

  @override
  String get close => 'סגור';

  @override
  String get moreInfo => 'מידע נוסף';

  @override
  String get deleteRide => 'מחיקת מתקן';

  @override
  String get cannotDelete =>
      'למתקן הזה יש היסטוריה לא ניתן למחוק אותו, ניתן רק להשבית אותו';

  @override
  String get deleteRideConfirmation =>
      'האם אתם בטוחים שאתם רוצים למחק מתקן זה?';

  @override
  String get cancel => 'ביטול';

  @override
  String get delete => 'מחק';

  @override
  String get deleteCrewMember => 'מחיקת איש צוות';

  @override
  String get deleteCrewMemberConfirmation =>
      'האם אתם בטוחים שאתם רוצים למחוק איש הצוות? ברגע שמאשרים את הפעולה לא נתן לשחזר נתוני איש הצוות הזה.';

  @override
  String get ok => 'אישור';

  @override
  String get errorInvalidCredentials => 'האימייל או הסיסמה שגויים';

  @override
  String get errorInvalidEmail => 'כתובת אימייל לא חוקית';

  @override
  String get errorEmailInUse => 'כתובת אימייל זו כבר בשימוש עבור משתמש אחר';

  @override
  String get errorTooManyRequests =>
      'יותר מדי ניסיונות, בבקשה לנסות שוב מאוחר יותר';

  @override
  String get errorNetwork => 'אין חיבור רשת, בבקשה לבדוק את החיבור ולנסות שוב';

  @override
  String get errorPermissionDenied => 'אין לך הרשאה לבצע פעולה זו';

  @override
  String get errorGeneric => 'משהו השתבש, בבקשה לנסות שוב ';
}
