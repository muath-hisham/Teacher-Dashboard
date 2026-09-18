import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'لوحة المعلم'**
  String get appTitle;

  /// No description provided for @classesTab.
  ///
  /// In ar, this message translates to:
  /// **'الصفوف'**
  String get classesTab;

  /// No description provided for @timetableTab.
  ///
  /// In ar, this message translates to:
  /// **'الجدول'**
  String get timetableTab;

  /// No description provided for @reportsTab.
  ///
  /// In ar, this message translates to:
  /// **'التقارير'**
  String get reportsTab;

  /// No description provided for @settingsTab.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTab;

  /// No description provided for @classesScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'الصفوف'**
  String get classesScreenTitle;

  /// No description provided for @classDetailsScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الصف'**
  String get classDetailsScreenTitle;

  /// No description provided for @attendanceScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'الحضور'**
  String get attendanceScreenTitle;

  /// No description provided for @reportsScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'التقارير'**
  String get reportsScreenTitle;

  /// No description provided for @timetableScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'الجدول الأسبوعي'**
  String get timetableScreenTitle;

  /// No description provided for @notesScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get notesScreenTitle;

  /// No description provided for @settingsScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsScreenTitle;

  /// No description provided for @phaseIndicator.
  ///
  /// In ar, this message translates to:
  /// **'سيتم التنفيذ في المرحلة {phase}'**
  String phaseIndicator(int phase);

  /// No description provided for @comingSoon.
  ///
  /// In ar, this message translates to:
  /// **'قريبًا'**
  String get comingSoon;

  /// No description provided for @classesDescription.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الصفوف والطلاب'**
  String get classesDescription;

  /// No description provided for @attendanceDescription.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل ومتابعة الحضور'**
  String get attendanceDescription;

  /// No description provided for @reportsDescription.
  ///
  /// In ar, this message translates to:
  /// **'تقارير وإحصائيات الحضور'**
  String get reportsDescription;

  /// No description provided for @timetableDescription.
  ///
  /// In ar, this message translates to:
  /// **'الجدول الأسبوعي للحصص'**
  String get timetableDescription;

  /// No description provided for @notesDescription.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات خاصة بالصفوف'**
  String get notesDescription;

  /// No description provided for @statusPresent.
  ///
  /// In ar, this message translates to:
  /// **'حاضر'**
  String get statusPresent;

  /// No description provided for @statusAbsent.
  ///
  /// In ar, this message translates to:
  /// **'غائب'**
  String get statusAbsent;

  /// No description provided for @statusLate.
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get statusLate;

  /// No description provided for @statusExcused.
  ///
  /// In ar, this message translates to:
  /// **'معذور'**
  String get statusExcused;

  /// No description provided for @settingsThemeMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع المظهر'**
  String get settingsThemeMode;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In ar, this message translates to:
  /// **'تلقائي (النظام)'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get settingsThemeDark;

  /// No description provided for @settingsCountryCode.
  ///
  /// In ar, this message translates to:
  /// **'رمز الدولة الافتراضي'**
  String get settingsCountryCode;

  /// No description provided for @settingsCountryCodeHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: +20'**
  String get settingsCountryCodeHint;

  /// No description provided for @settingsCountryCodeInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رمز غير صالح (مثال: +20)'**
  String get settingsCountryCodeInvalid;

  /// No description provided for @settingsLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get settingsLanguageArabic;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In ar, this message translates to:
  /// **'تلقائي (النظام)'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsGeneral.
  ///
  /// In ar, this message translates to:
  /// **'عام'**
  String get settingsGeneral;

  /// No description provided for @settingsAppearance.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get settingsAppearance;

  /// No description provided for @addClass.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صف'**
  String get addClass;

  /// No description provided for @editClass.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الصف'**
  String get editClass;

  /// No description provided for @deleteClass.
  ///
  /// In ar, this message translates to:
  /// **'حذف الصف'**
  String get deleteClass;

  /// No description provided for @className.
  ///
  /// In ar, this message translates to:
  /// **'اسم الصف'**
  String get className;

  /// No description provided for @classNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: الصف الأول'**
  String get classNameHint;

  /// No description provided for @classNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اسم الصف مطلوب'**
  String get classNameRequired;

  /// No description provided for @classNameTooLong.
  ///
  /// In ar, this message translates to:
  /// **'اسم الصف طويل جدًا'**
  String get classNameTooLong;

  /// No description provided for @deleteClassConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف الصف؟'**
  String get deleteClassConfirmTitle;

  /// No description provided for @deleteClassConfirmBody.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف جميع الطلاب والحصص وسجلات الحضور المرتبطة بهذا الصف نهائيًا.'**
  String get deleteClassConfirmBody;

  /// No description provided for @noClassesTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد صفوف بعد'**
  String get noClassesTitle;

  /// No description provided for @noClassesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد صفوف لعرض تقاريرها.'**
  String get noClassesSubtitle;

  /// No description provided for @studentCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{لا يوجد طلاب} =1{طالب واحد} =2{طالبان} few{{count} طلاب} other{{count} طالب}}'**
  String studentCount(int count);

  /// No description provided for @addStudent.
  ///
  /// In ar, this message translates to:
  /// **'إضافة طالب'**
  String get addStudent;

  /// No description provided for @editStudent.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الطالب'**
  String get editStudent;

  /// No description provided for @deleteStudent.
  ///
  /// In ar, this message translates to:
  /// **'حذف الطالب'**
  String get deleteStudent;

  /// No description provided for @studentName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الطالب'**
  String get studentName;

  /// No description provided for @studentNameHint.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get studentNameHint;

  /// No description provided for @studentNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اسم الطالب مطلوب'**
  String get studentNameRequired;

  /// No description provided for @studentPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get studentPhone;

  /// No description provided for @studentPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف الطالب'**
  String get studentPhoneHint;

  /// No description provided for @studentGuardianPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم ولي الأمر'**
  String get studentGuardianPhone;

  /// No description provided for @studentGuardianPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف ولي الأمر'**
  String get studentGuardianPhoneHint;

  /// No description provided for @deleteStudentConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف الطالب؟'**
  String get deleteStudentConfirmTitle;

  /// No description provided for @deleteStudentConfirmBody.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف الطالب وجميع سجلات حضوره نهائيًا.'**
  String get deleteStudentConfirmBody;

  /// No description provided for @noStudentsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد طلاب بعد'**
  String get noStudentsTitle;

  /// No description provided for @noStudentsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أضف طالبك الأول لهذا الصف'**
  String get noStudentsSubtitle;

  /// No description provided for @searchStudents.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن طالب...'**
  String get searchStudents;

  /// No description provided for @noStudentsFoundTitle.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على طلاب'**
  String get noStudentsFoundTitle;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف غير صالح'**
  String get invalidPhoneNumber;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @rename.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تسمية'**
  String get rename;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @sessions.
  ///
  /// In ar, this message translates to:
  /// **'الحصص'**
  String get sessions;

  /// No description provided for @addSession.
  ///
  /// In ar, this message translates to:
  /// **'إضافة حصة'**
  String get addSession;

  /// No description provided for @editSession.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الحصة'**
  String get editSession;

  /// No description provided for @deleteSession.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحصة'**
  String get deleteSession;

  /// No description provided for @sessionTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الحصة'**
  String get sessionTitle;

  /// No description provided for @sessionTitleHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: الدرس الأول'**
  String get sessionTitleHint;

  /// No description provided for @sessionTitleRequired.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الحصة مطلوب'**
  String get sessionTitleRequired;

  /// No description provided for @sessionDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الحصة'**
  String get sessionDate;

  /// No description provided for @sessionTime.
  ///
  /// In ar, this message translates to:
  /// **'وقت الحصة'**
  String get sessionTime;

  /// No description provided for @sessionLink.
  ///
  /// In ar, this message translates to:
  /// **'رابط الحصة (اختياري)'**
  String get sessionLink;

  /// No description provided for @sessionLinkHint.
  ///
  /// In ar, this message translates to:
  /// **'رابط تيمز، زووم، إلخ'**
  String get sessionLinkHint;

  /// No description provided for @deleteSessionConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحصة؟'**
  String get deleteSessionConfirmTitle;

  /// No description provided for @deleteSessionConfirmBody.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف الحصة وسجلات الحضور المرتبطة بها نهائيًا.'**
  String get deleteSessionConfirmBody;

  /// No description provided for @noSessionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حصص بعد'**
  String get noSessionsTitle;

  /// No description provided for @noSessionsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أضف حصتك الأولى'**
  String get noSessionsSubtitle;

  /// No description provided for @attendance.
  ///
  /// In ar, this message translates to:
  /// **'الحضور'**
  String get attendance;

  /// No description provided for @markAllPresent.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الكل كحاضر'**
  String get markAllPresent;

  /// No description provided for @markAllAbsent.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الكل كغائب'**
  String get markAllAbsent;

  /// No description provided for @attendanceNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة (اختياري)'**
  String get attendanceNote;

  /// No description provided for @attendanceSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الحضور بنجاح'**
  String get attendanceSaved;

  /// No description provided for @sendWhatsApp.
  ///
  /// In ar, this message translates to:
  /// **'إرسال عبر واتساب'**
  String get sendWhatsApp;

  /// No description provided for @whatsappAll.
  ///
  /// In ar, this message translates to:
  /// **'إلى جميع الطلاب'**
  String get whatsappAll;

  /// No description provided for @whatsappAbsent.
  ///
  /// In ar, this message translates to:
  /// **'إلى الغائبين فقط'**
  String get whatsappAbsent;

  /// No description provided for @whatsappLaunchFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر فتح تطبيق واتساب. تأكد من تثبيته على جهازك.'**
  String get whatsappLaunchFailed;

  /// No description provided for @whatsappTemplate.
  ///
  /// In ar, this message translates to:
  /// **'السلام عليكم، رابط حصة ({title}): {link}'**
  String whatsappTemplate(String title, String link);

  /// No description provided for @timetableAndNotesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الجدول والملاحظات'**
  String get timetableAndNotesTitle;

  /// No description provided for @timetable.
  ///
  /// In ar, this message translates to:
  /// **'الجدول'**
  String get timetable;

  /// No description provided for @notes.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get notes;

  /// No description provided for @sunday.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In ar, this message translates to:
  /// **'الإثنين'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get saturday;

  /// No description provided for @assignClass.
  ///
  /// In ar, this message translates to:
  /// **'تعيين صف'**
  String get assignClass;

  /// No description provided for @clear.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get clear;

  /// No description provided for @noNotesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد ملاحظات.'**
  String get noNotesSubtitle;

  /// No description provided for @addNote.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ملاحظة'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملاحظة'**
  String get editNote;

  /// No description provided for @attachToClass.
  ///
  /// In ar, this message translates to:
  /// **'إرفاق بصف (اختياري)'**
  String get attachToClass;

  /// No description provided for @none.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد'**
  String get none;

  /// No description provided for @noteBody.
  ///
  /// In ar, this message translates to:
  /// **'نص الملاحظة'**
  String get noteBody;

  /// No description provided for @requiredField.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب'**
  String get requiredField;

  /// No description provided for @reports.
  ///
  /// In ar, this message translates to:
  /// **'التقارير'**
  String get reports;

  /// No description provided for @attendanceRate.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الحضور'**
  String get attendanceRate;

  /// No description provided for @totalSessions.
  ///
  /// In ar, this message translates to:
  /// **'الحصص'**
  String get totalSessions;

  /// No description provided for @studentRankings.
  ///
  /// In ar, this message translates to:
  /// **'غيابات الطلاب'**
  String get studentRankings;

  /// No description provided for @studentReport.
  ///
  /// In ar, this message translates to:
  /// **'تقرير الطالب'**
  String get studentReport;

  /// No description provided for @statusBreakdown.
  ///
  /// In ar, this message translates to:
  /// **'تفصيل الحضور'**
  String get statusBreakdown;

  /// No description provided for @sessionHistory.
  ///
  /// In ar, this message translates to:
  /// **'سجل الحصص'**
  String get sessionHistory;

  /// No description provided for @backupSection.
  ///
  /// In ar, this message translates to:
  /// **'النسخ الاحتياطي والاستعادة'**
  String get backupSection;

  /// No description provided for @exportDatabase.
  ///
  /// In ar, this message translates to:
  /// **'تصدير قاعدة البيانات'**
  String get exportDatabase;

  /// No description provided for @importDatabase.
  ///
  /// In ar, this message translates to:
  /// **'استيراد قاعدة البيانات'**
  String get importDatabase;

  /// No description provided for @importWarningTitle.
  ///
  /// In ar, this message translates to:
  /// **'تحذير استيراد البيانات'**
  String get importWarningTitle;

  /// No description provided for @importWarningBody.
  ///
  /// In ar, this message translates to:
  /// **'سيؤدي استيراد قاعدة البيانات إلى استبدال جميع البيانات الحالية بالكامل ولن يمكن التراجع عن هذه العملية. هل أنت متأكد؟'**
  String get importWarningBody;

  /// No description provided for @restoreSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تمت استعادة البيانات بنجاح'**
  String get restoreSuccess;

  /// No description provided for @deleteNoteConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف الملاحظة؟'**
  String get deleteNoteConfirmTitle;

  /// No description provided for @deleteNoteConfirmBody.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف هذه الملاحظة نهائيًا. هل أنت متأكد؟'**
  String get deleteNoteConfirmBody;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
