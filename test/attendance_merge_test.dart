import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_model.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_status.dart';
import 'package:teacher_dashboard/features/students/domain/student_model.dart';
import 'package:teacher_dashboard/features/attendance/presentation/providers/attendance_providers.dart';

void main() {
  group('buildAttendanceState pure logic', () {
    final students = [
      StudentModel(
        id: 1,
        classId: 10,
        name: 'Ahmed',
        phone: '+20111',
        createdAt: DateTime.now(),
      ),
      StudentModel(
        id: 2,
        classId: 10,
        name: 'Ali',
        createdAt: DateTime.now(),
      ),
      StudentModel(
        id: 3,
        classId: 10,
        name: 'Sara',
        guardianPhone: '+20222',
        createdAt: DateTime.now(),
      ),
    ];

    test('defaults to present when no DB records exist', () {
      final rows = buildAttendanceState(students, []);
      
      expect(rows.length, 3);
      expect(rows[0].studentId, 1);
      expect(rows[0].status, AttendanceStatus.present);
      expect(rows[0].note, isNull);

      expect(rows[1].studentId, 2);
      expect(rows[1].status, AttendanceStatus.present);

      expect(rows[2].studentId, 3);
      expect(rows[2].status, AttendanceStatus.present);
    });

    test('merges existing DB records correctly', () {
      final existing = [
        const AttendanceModel(
          sessionId: 99,
          studentId: 1,
          status: AttendanceStatus.absent,
          note: 'Sick',
        ),
        const AttendanceModel(
          sessionId: 99,
          studentId: 3,
          status: AttendanceStatus.late,
        ),
      ];

      final rows = buildAttendanceState(students, existing);
      
      expect(rows.length, 3);
      
      // Ahmed (id: 1) has DB record
      expect(rows[0].status, AttendanceStatus.absent);
      expect(rows[0].note, 'Sick');

      // Ali (id: 2) has NO DB record -> defaults to present
      expect(rows[1].status, AttendanceStatus.present);
      expect(rows[1].note, isNull);

      // Sara (id: 3) has DB record
      expect(rows[2].status, AttendanceStatus.late);
      expect(rows[2].note, isNull);
    });
  });
}
