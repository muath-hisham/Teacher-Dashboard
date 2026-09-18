import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/attendance/data/attendance_repository.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_model.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_status.dart';
import 'package:teacher_dashboard/features/students/domain/student_model.dart';
import 'package:teacher_dashboard/features/students/presentation/providers/students_providers.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository(DatabaseHelper.instance);
});

/// Pure logic for merging students and existing DB attendance.
/// Defaults missing records to 'present'.
List<AttendanceRowState> buildAttendanceState(
  List<StudentModel> students,
  List<AttendanceModel> existingRecords,
) {
  final recordMap = {for (final r in existingRecords) r.studentId: r};

  return students.map((s) {
    final record = recordMap[s.id];
    return AttendanceRowState(
      studentId: s.id,
      studentName: s.name,
      studentPhone: s.phone,
      guardianPhone: s.guardianPhone,
      status: record?.status ?? AttendanceStatus.present,
      note: record?.note,
    );
  }).toList();
}

/// Provider that manages the local form state for an attendance session.
final attendanceFormProvider = StateNotifierProvider.family
    .autoDispose<AttendanceFormNotifier, AsyncValue<List<AttendanceRowState>>, int>(
  (ref, sessionId) => AttendanceFormNotifier(ref, sessionId),
);

class AttendanceFormNotifier
    extends StateNotifier<AsyncValue<List<AttendanceRowState>>> {
  AttendanceFormNotifier(this.ref, this.sessionId)
      : super(const AsyncValue.loading());

  final Ref ref;
  final int sessionId;

  /// Loads the students for [classId] and merges them with existing attendance.
  Future<void> init(int classId) async {
    state = const AsyncValue.loading();
    try {
      final students = await ref.read(studentRepositoryProvider).getByClassId(classId);
      final records = await ref.read(attendanceRepositoryProvider).getBySessionId(sessionId);

      final merged = buildAttendanceState(students, records);
      state = AsyncValue.data(merged);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updateStatus(int studentId, AttendanceStatus newStatus) {
    state.whenData((rows) {
      final updated = rows.map((r) {
        if (r.studentId == studentId) {
          return r.copyWith(status: newStatus);
        }
        return r;
      }).toList();
      state = AsyncValue.data(updated);
    });
  }

  void updateNote(int studentId, String? note) {
    state.whenData((rows) {
      final updated = rows.map((r) {
        if (r.studentId == studentId) {
          // Normalize empty notes to null
          final trimmed = note?.trim();
          final isNullOrEmpty = trimmed == null || trimmed.isEmpty;
          return r.copyWith(
            note: isNullOrEmpty ? null : trimmed,
            clearNote: isNullOrEmpty,
          );
        }
        return r;
      }).toList();
      state = AsyncValue.data(updated);
    });
  }

  void markAll(AttendanceStatus status) {
    state.whenData((rows) {
      final updated = rows.map((r) => r.copyWith(status: status)).toList();
      state = AsyncValue.data(updated);
    });
  }

  Future<void> save() async {
    final rows = state.valueOrNull;
    if (rows == null) return;

    final records = rows.map((r) {
      return AttendanceModel(
        sessionId: sessionId,
        studentId: r.studentId,
        status: r.status,
        note: r.note,
      );
    }).toList();

    await ref.read(attendanceRepositoryProvider).saveSessionAttendance(sessionId, records);
  }
}
