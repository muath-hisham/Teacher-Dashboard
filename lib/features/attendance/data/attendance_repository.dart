import 'package:teacher_dashboard/core/database/database_constants.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_model.dart';

class AttendanceRepository {
  AttendanceRepository(this._dbHelper);

  final DatabaseHelper _dbHelper;

  /// Returns all attendance records for a session.
  Future<List<AttendanceModel>> getBySessionId(int sessionId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DbTables.attendance,
      where: '${DbColumns.sessionId} = ?',
      whereArgs: [sessionId],
    );
    return rows.map(AttendanceModel.fromMap).toList();
  }

  /// Idempotent save for the entire session.
  ///
  /// Uses UPSERT (ON CONFLICT DO UPDATE) matching (session_id, student_id)
  /// to ensure we don't duplicate rows or churn IDs.
  Future<void> saveSessionAttendance(
    int sessionId,
    List<AttendanceModel> records,
  ) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final record in records) {
        batch.rawUpdate(
          '''
          UPDATE ${DbTables.attendance}
          SET ${DbColumns.status} = ?, ${DbColumns.note} = ?
          WHERE ${DbColumns.sessionId} = ? AND ${DbColumns.studentId} = ?
          ''',
          [
            record.status.dbValue,
            record.note?.trim(),
            sessionId,
            record.studentId,
          ],
        );

        batch.rawInsert(
          '''
          INSERT OR IGNORE INTO ${DbTables.attendance} (
            ${DbColumns.sessionId},
            ${DbColumns.studentId},
            ${DbColumns.status},
            ${DbColumns.note}
          )
          VALUES (?, ?, ?, ?)
          ''',
          [
            sessionId,
            record.studentId,
            record.status.dbValue,
            record.note?.trim(),
          ],
        );
      }

      await batch.commit(noResult: true);
    });
  }
}
