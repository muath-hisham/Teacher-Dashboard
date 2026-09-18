import 'package:teacher_dashboard/core/database/database_constants.dart';

import 'attendance_status.dart';

/// A database row for attendance.
class AttendanceModel {
  const AttendanceModel({
    this.id,
    required this.sessionId,
    required this.studentId,
    required this.status,
    this.note,
  });

  final int? id;
  final int sessionId;
  final int studentId;
  final AttendanceStatus status;
  final String? note;

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map[DbColumns.id] as int,
      sessionId: map[DbColumns.sessionId] as int,
      studentId: map[DbColumns.studentId] as int,
      status: AttendanceStatus.fromDb(map[DbColumns.status] as String),
      note: map[DbColumns.note] as String?,
    );
  }
}

/// UI state merging a student with their attendance record.
class AttendanceRowState {
  const AttendanceRowState({
    required this.studentId,
    required this.studentName,
    this.studentPhone,
    this.guardianPhone,
    required this.status,
    this.note,
  });

  final int studentId;
  final String studentName;
  final String? studentPhone;
  final String? guardianPhone;
  final AttendanceStatus status;
  final String? note;

  AttendanceRowState copyWith({
    AttendanceStatus? status,
    String? note,
    bool clearNote = false,
  }) {
    return AttendanceRowState(
      studentId: studentId,
      studentName: studentName,
      studentPhone: studentPhone,
      guardianPhone: guardianPhone,
      status: status ?? this.status,
      note: clearNote ? null : (note ?? this.note),
    );
  }
}
