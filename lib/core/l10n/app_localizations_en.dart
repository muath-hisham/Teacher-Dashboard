// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Teacher Dashboard';

  @override
  String get classesTab => 'Classes';

  @override
  String get timetableTab => 'Timetable';

  @override
  String get reportsTab => 'Reports';

  @override
  String get settingsTab => 'Settings';

  @override
  String get classesScreenTitle => 'Classes';

  @override
  String get classDetailsScreenTitle => 'Class Details';

  @override
  String get attendanceScreenTitle => 'Attendance';

  @override
  String get reportsScreenTitle => 'Reports';

  @override
  String get timetableScreenTitle => 'Weekly Timetable';

  @override
  String get notesScreenTitle => 'Notes';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String phaseIndicator(int phase) {
    return 'Coming in Phase $phase';
  }

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get classesDescription => 'Manage classes and students';

  @override
  String get attendanceDescription => 'Record and track attendance';

  @override
  String get reportsDescription => 'Attendance reports and statistics';

  @override
  String get timetableDescription => 'Weekly class timetable';

  @override
  String get notesDescription => 'Class-specific notes';

  @override
  String get statusPresent => 'Present';

  @override
  String get statusAbsent => 'Absent';

  @override
  String get statusLate => 'Late';

  @override
  String get statusExcused => 'Excused';

  @override
  String get settingsThemeMode => 'Theme mode';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsCountryCode => 'Default country code';

  @override
  String get settingsCountryCodeHint => 'e.g. +20';

  @override
  String get settingsCountryCodeInvalid => 'Invalid code (e.g. +20)';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get addClass => 'Add class';

  @override
  String get editClass => 'Edit class';

  @override
  String get deleteClass => 'Delete class';

  @override
  String get className => 'Class name';

  @override
  String get classNameHint => 'e.g. Grade 1';

  @override
  String get classNameRequired => 'Class name is required';

  @override
  String get classNameTooLong => 'Class name is too long';

  @override
  String get deleteClassConfirmTitle => 'Delete class?';

  @override
  String get deleteClassConfirmBody =>
      'All students, sessions, and attendance records for this class will be permanently deleted.';

  @override
  String get noClassesTitle => 'No classes yet';

  @override
  String get noClassesSubtitle => 'No classes available.';

  @override
  String studentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count students',
      one: '1 student',
      zero: 'No students',
    );
    return '$_temp0';
  }

  @override
  String get addStudent => 'Add student';

  @override
  String get editStudent => 'Edit student';

  @override
  String get deleteStudent => 'Delete student';

  @override
  String get studentName => 'Student name';

  @override
  String get studentNameHint => 'Full name';

  @override
  String get studentNameRequired => 'Student name is required';

  @override
  String get studentPhone => 'Phone number';

  @override
  String get studentPhoneHint => 'Student phone number';

  @override
  String get studentGuardianPhone => 'Guardian phone';

  @override
  String get studentGuardianPhoneHint => 'Guardian phone number';

  @override
  String get deleteStudentConfirmTitle => 'Delete student?';

  @override
  String get deleteStudentConfirmBody =>
      'The student and all their attendance records will be permanently deleted.';

  @override
  String get noStudentsTitle => 'No students yet';

  @override
  String get noStudentsSubtitle => 'Add your first student to this class';

  @override
  String get searchStudents => 'Search students...';

  @override
  String get noStudentsFoundTitle => 'No students found';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get rename => 'Rename';

  @override
  String get search => 'Search';

  @override
  String get sessions => 'Sessions';

  @override
  String get addSession => 'Add session';

  @override
  String get editSession => 'Edit session';

  @override
  String get deleteSession => 'Delete session';

  @override
  String get sessionTitle => 'Session title';

  @override
  String get sessionTitleHint => 'e.g. Lesson 1';

  @override
  String get sessionTitleRequired => 'Session title is required';

  @override
  String get sessionDate => 'Date';

  @override
  String get sessionTime => 'Time';

  @override
  String get sessionLink => 'Link (optional)';

  @override
  String get sessionLinkHint => 'Teams, Zoom link etc.';

  @override
  String get deleteSessionConfirmTitle => 'Delete session?';

  @override
  String get deleteSessionConfirmBody =>
      'The session and its attendance records will be permanently deleted.';

  @override
  String get noSessionsTitle => 'No sessions yet';

  @override
  String get noSessionsSubtitle => 'Add your first session';

  @override
  String get attendance => 'Attendance';

  @override
  String get markAllPresent => 'Mark all present';

  @override
  String get markAllAbsent => 'Mark all absent';

  @override
  String get attendanceNote => 'Note (optional)';

  @override
  String get attendanceSaved => 'Attendance saved successfully';

  @override
  String get sendWhatsApp => 'Send via WhatsApp';

  @override
  String get whatsappAll => 'To all students';

  @override
  String get whatsappAbsent => 'To absent students only';

  @override
  String get whatsappLaunchFailed =>
      'Could not launch WhatsApp. Ensure it is installed.';

  @override
  String whatsappTemplate(String title, String link) {
    return 'Hello, here is the link for ($title): $link';
  }

  @override
  String get timetableAndNotesTitle => 'Timetable & Notes';

  @override
  String get timetable => 'Timetable';

  @override
  String get notes => 'Notes';

  @override
  String get sunday => 'Sun';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get assignClass => 'Assign Class';

  @override
  String get clear => 'Clear';

  @override
  String get noNotesSubtitle => 'No notes available.';

  @override
  String get addNote => 'Add Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get attachToClass => 'Attach to class (optional)';

  @override
  String get none => 'None';

  @override
  String get noteBody => 'Note content';

  @override
  String get requiredField => 'Required';

  @override
  String get reports => 'Reports';

  @override
  String get attendanceRate => 'Attendance Rate';

  @override
  String get totalSessions => 'Sessions';

  @override
  String get studentRankings => 'Student Absences';

  @override
  String get studentReport => 'Student Report';

  @override
  String get statusBreakdown => 'Status Breakdown';

  @override
  String get sessionHistory => 'Session History';

  @override
  String get backupSection => 'Backup & Restore';

  @override
  String get exportDatabase => 'Export Database';

  @override
  String get importDatabase => 'Import Database';

  @override
  String get importWarningTitle => 'Import Warning';

  @override
  String get importWarningBody =>
      'Importing a database will entirely replace your current data and cannot be undone. Are you sure?';

  @override
  String get restoreSuccess => 'Database restored successfully.';

  @override
  String get deleteNoteConfirmTitle => 'Delete note?';

  @override
  String get deleteNoteConfirmBody =>
      'This note will be permanently deleted. Are you sure?';
}
