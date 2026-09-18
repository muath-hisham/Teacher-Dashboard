import 'package:teacher_dashboard/core/database/database_constants.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/attendance/domain/session_model.dart';

class SessionRepository {
  SessionRepository(this._dbHelper);

  final DatabaseHelper _dbHelper;

  /// Returns all sessions for [classId], ordered newest first.
  Future<List<SessionModel>> getByClassId(int classId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DbTables.sessions,
      where: '${DbColumns.classId} = ?',
      whereArgs: [classId],
      orderBy: '${DbColumns.date} DESC, ${DbColumns.startTime} DESC, ${DbColumns.id} DESC',
    );
    return rows.map(SessionModel.fromMap).toList();
  }

  Future<SessionModel?> getById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DbTables.sessions,
      where: '${DbColumns.id} = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return SessionModel.fromMap(rows.first);
  }

  Future<int> insert({
    required int classId,
    required String title,
    String? link,
    required String date,
    required String startTime,
  }) async {
    final db = await _dbHelper.database;
    return db.insert(DbTables.sessions, {
      DbColumns.classId: classId,
      DbColumns.title: title.trim(),
      DbColumns.link: link?.trim(),
      DbColumns.date: date,
      DbColumns.startTime: startTime,
    });
  }

  Future<void> update({
    required int id,
    required String title,
    String? link,
    required String date,
    required String startTime,
  }) async {
    final db = await _dbHelper.database;
    await db.update(
      DbTables.sessions,
      {
        DbColumns.title: title.trim(),
        DbColumns.link: link?.trim(),
        DbColumns.date: date,
        DbColumns.startTime: startTime,
      },
      where: '${DbColumns.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DbTables.sessions,
      where: '${DbColumns.id} = ?',
      whereArgs: [id],
    );
  }
}
