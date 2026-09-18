// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'لوحة المعلم';

  @override
  String get classesTab => 'الصفوف';

  @override
  String get timetableTab => 'الجدول';

  @override
  String get reportsTab => 'التقارير';

  @override
  String get settingsTab => 'الإعدادات';

  @override
  String get classesScreenTitle => 'الصفوف';

  @override
  String get classDetailsScreenTitle => 'تفاصيل الصف';

  @override
  String get attendanceScreenTitle => 'الحضور';

  @override
  String get reportsScreenTitle => 'التقارير';

  @override
  String get timetableScreenTitle => 'الجدول الأسبوعي';

  @override
  String get notesScreenTitle => 'الملاحظات';

  @override
  String get settingsScreenTitle => 'الإعدادات';

  @override
  String phaseIndicator(int phase) {
    return 'سيتم التنفيذ في المرحلة $phase';
  }

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get classesDescription => 'إدارة الصفوف والطلاب';

  @override
  String get attendanceDescription => 'تسجيل ومتابعة الحضور';

  @override
  String get reportsDescription => 'تقارير وإحصائيات الحضور';

  @override
  String get timetableDescription => 'الجدول الأسبوعي للحصص';

  @override
  String get notesDescription => 'ملاحظات خاصة بالصفوف';

  @override
  String get statusPresent => 'حاضر';

  @override
  String get statusAbsent => 'غائب';

  @override
  String get statusLate => 'متأخر';

  @override
  String get statusExcused => 'معذور';

  @override
  String get settingsThemeMode => 'وضع المظهر';

  @override
  String get settingsThemeSystem => 'تلقائي (النظام)';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsCountryCode => 'رمز الدولة الافتراضي';

  @override
  String get settingsCountryCodeHint => 'مثال: +20';

  @override
  String get settingsCountryCodeInvalid => 'رمز غير صالح (مثال: +20)';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSystem => 'تلقائي (النظام)';

  @override
  String get settingsGeneral => 'عام';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get addClass => 'إضافة صف';

  @override
  String get editClass => 'تعديل الصف';

  @override
  String get deleteClass => 'حذف الصف';

  @override
  String get className => 'اسم الصف';

  @override
  String get classNameHint => 'مثال: الصف الأول';

  @override
  String get classNameRequired => 'اسم الصف مطلوب';

  @override
  String get classNameTooLong => 'اسم الصف طويل جدًا';

  @override
  String get deleteClassConfirmTitle => 'حذف الصف؟';

  @override
  String get deleteClassConfirmBody =>
      'سيتم حذف جميع الطلاب والحصص وسجلات الحضور المرتبطة بهذا الصف نهائيًا.';

  @override
  String get noClassesTitle => 'لا توجد صفوف بعد';

  @override
  String get noClassesSubtitle => 'لا توجد صفوف لعرض تقاريرها.';

  @override
  String studentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count طالب',
      few: '$count طلاب',
      two: 'طالبان',
      one: 'طالب واحد',
      zero: 'لا يوجد طلاب',
    );
    return '$_temp0';
  }

  @override
  String get addStudent => 'إضافة طالب';

  @override
  String get editStudent => 'تعديل الطالب';

  @override
  String get deleteStudent => 'حذف الطالب';

  @override
  String get studentName => 'اسم الطالب';

  @override
  String get studentNameHint => 'الاسم الكامل';

  @override
  String get studentNameRequired => 'اسم الطالب مطلوب';

  @override
  String get studentPhone => 'رقم الهاتف';

  @override
  String get studentPhoneHint => 'رقم هاتف الطالب';

  @override
  String get studentGuardianPhone => 'رقم ولي الأمر';

  @override
  String get studentGuardianPhoneHint => 'رقم هاتف ولي الأمر';

  @override
  String get deleteStudentConfirmTitle => 'حذف الطالب؟';

  @override
  String get deleteStudentConfirmBody =>
      'سيتم حذف الطالب وجميع سجلات حضوره نهائيًا.';

  @override
  String get noStudentsTitle => 'لا يوجد طلاب بعد';

  @override
  String get noStudentsSubtitle => 'أضف طالبك الأول لهذا الصف';

  @override
  String get searchStudents => 'بحث عن طالب...';

  @override
  String get noStudentsFoundTitle => 'لم يتم العثور على طلاب';

  @override
  String get invalidPhoneNumber => 'رقم هاتف غير صالح';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get search => 'بحث';

  @override
  String get sessions => 'الحصص';

  @override
  String get addSession => 'إضافة حصة';

  @override
  String get editSession => 'تعديل الحصة';

  @override
  String get deleteSession => 'حذف الحصة';

  @override
  String get sessionTitle => 'عنوان الحصة';

  @override
  String get sessionTitleHint => 'مثال: الدرس الأول';

  @override
  String get sessionTitleRequired => 'عنوان الحصة مطلوب';

  @override
  String get sessionDate => 'تاريخ الحصة';

  @override
  String get sessionTime => 'وقت الحصة';

  @override
  String get sessionLink => 'رابط الحصة (اختياري)';

  @override
  String get sessionLinkHint => 'رابط تيمز، زووم، إلخ';

  @override
  String get deleteSessionConfirmTitle => 'حذف الحصة؟';

  @override
  String get deleteSessionConfirmBody =>
      'سيتم حذف الحصة وسجلات الحضور المرتبطة بها نهائيًا.';

  @override
  String get noSessionsTitle => 'لا توجد حصص بعد';

  @override
  String get noSessionsSubtitle => 'أضف حصتك الأولى';

  @override
  String get attendance => 'الحضور';

  @override
  String get markAllPresent => 'تحديد الكل كحاضر';

  @override
  String get markAllAbsent => 'تحديد الكل كغائب';

  @override
  String get attendanceNote => 'ملاحظة (اختياري)';

  @override
  String get attendanceSaved => 'تم حفظ الحضور بنجاح';

  @override
  String get sendWhatsApp => 'إرسال عبر واتساب';

  @override
  String get whatsappAll => 'إلى جميع الطلاب';

  @override
  String get whatsappAbsent => 'إلى الغائبين فقط';

  @override
  String get whatsappLaunchFailed =>
      'تعذر فتح تطبيق واتساب. تأكد من تثبيته على جهازك.';

  @override
  String whatsappTemplate(String title, String link) {
    return 'السلام عليكم، رابط حصة ($title): $link';
  }

  @override
  String get timetableAndNotesTitle => 'الجدول والملاحظات';

  @override
  String get timetable => 'الجدول';

  @override
  String get notes => 'الملاحظات';

  @override
  String get sunday => 'الأحد';

  @override
  String get monday => 'الإثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get assignClass => 'تعيين صف';

  @override
  String get clear => 'مسح';

  @override
  String get noNotesSubtitle => 'لا توجد ملاحظات.';

  @override
  String get addNote => 'إضافة ملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get attachToClass => 'إرفاق بصف (اختياري)';

  @override
  String get none => 'لا يوجد';

  @override
  String get noteBody => 'نص الملاحظة';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get reports => 'التقارير';

  @override
  String get attendanceRate => 'نسبة الحضور';

  @override
  String get totalSessions => 'الحصص';

  @override
  String get studentRankings => 'غيابات الطلاب';

  @override
  String get studentReport => 'تقرير الطالب';

  @override
  String get statusBreakdown => 'تفصيل الحضور';

  @override
  String get sessionHistory => 'سجل الحصص';

  @override
  String get backupSection => 'النسخ الاحتياطي والاستعادة';

  @override
  String get exportDatabase => 'تصدير قاعدة البيانات';

  @override
  String get importDatabase => 'استيراد قاعدة البيانات';

  @override
  String get importWarningTitle => 'تحذير استيراد البيانات';

  @override
  String get importWarningBody =>
      'سيؤدي استيراد قاعدة البيانات إلى استبدال جميع البيانات الحالية بالكامل ولن يمكن التراجع عن هذه العملية. هل أنت متأكد؟';

  @override
  String get restoreSuccess => 'تمت استعادة البيانات بنجاح';

  @override
  String get deleteNoteConfirmTitle => 'حذف الملاحظة؟';

  @override
  String get deleteNoteConfirmBody =>
      'سيتم حذف هذه الملاحظة نهائيًا. هل أنت متأكد؟';
}
