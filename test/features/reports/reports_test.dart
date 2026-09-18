import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_status.dart';
import 'package:teacher_dashboard/features/reports/domain/report_models.dart';

void main() {
  group('Report Models', () {
    test('ClassReportModel instantiates correctly', () {
      final report = ClassReportModel(
        classId: 1,
        className: 'Math',
        totalSessions: 10,
        attendanceRate: 0.8,
        studentRankings: [
          const StudentAbsenceRank(studentId: 1, studentName: 'Alice', absences: 2),
        ],
      );

      expect(report.classId, 1);
      expect(report.attendanceRate, 0.8);
      expect(report.studentRankings.first.absences, 2);
    });

    test('StudentReportModel instantiates correctly', () {
      final report = StudentReportModel(
        studentId: 1,
        studentName: 'Alice',
        totalSessions: 10,
        attendanceRate: 0.8,
        statusBreakdown: {
          AttendanceStatus.present: 8,
          AttendanceStatus.absent: 2,
        },
        history: [],
      );

      expect(report.studentId, 1);
      expect(report.statusBreakdown[AttendanceStatus.present], 8);
    });
  });
}
