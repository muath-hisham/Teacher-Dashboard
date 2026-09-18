import 'package:teacher_dashboard/features/attendance/domain/attendance_status.dart';

class StudentAbsenceRank {
  const StudentAbsenceRank({
    required this.studentId,
    required this.studentName,
    required this.absences,
  });

  final int studentId;
  final String studentName;
  final int absences;
}

class ClassReportModel {
  const ClassReportModel({
    required this.classId,
    required this.className,
    required this.totalSessions,
    required this.attendanceRate,
    required this.studentRankings,
  });

  final int classId;
  final String className;
  final int totalSessions;
  final double? attendanceRate;
  final List<StudentAbsenceRank> studentRankings;
}

class AttendanceSessionHistory {
  const AttendanceSessionHistory({
    required this.sessionId,
    required this.sessionTitle,
    required this.date,
    required this.status,
    this.note,
  });

  final int sessionId;
  final String sessionTitle;
  final DateTime date;
  final AttendanceStatus status;
  final String? note;
}

class StudentReportModel {
  const StudentReportModel({
    required this.studentId,
    required this.studentName,
    required this.totalSessions,
    required this.attendanceRate,
    required this.statusBreakdown,
    required this.history,
  });

  final int studentId;
  final String studentName;
  final int totalSessions;
  final double? attendanceRate;
  final Map<AttendanceStatus, int> statusBreakdown;
  final List<AttendanceSessionHistory> history;
}
