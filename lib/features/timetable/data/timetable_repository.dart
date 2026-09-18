import 'package:teacher_dashboard/core/database/database_constants.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/timetable/domain/timetable_model.dart';

class TimetableRepository {
  TimetableRepository(this._dbHelper);

  final DatabaseHelper _dbHelper;

  Future<List<TimetableModel>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query(DbTables.timetable);
    return rows.map(TimetableModel.fromMap).toList();
  }

  /// Sets or clears a timetable cell.
  Future<void> setCell(int dayIndex, int periodIndex, int? classId) async {
    final db = await _dbHelper.database;

    if (classId == null) {
      await db.delete(
        DbTables.timetable,
        where: '${DbColumns.dayIndex} = ? AND ${DbColumns.periodIndex} = ?',
        whereArgs: [dayIndex, periodIndex],
      );
    } else {
      await db.transaction((txn) async {
        final batch = txn.batch();
        batch.rawUpdate(
          '''
          UPDATE ${DbTables.timetable}
          SET ${DbColumns.classId} = ?
          WHERE ${DbColumns.dayIndex} = ? AND ${DbColumns.periodIndex} = ?
          ''',
          [classId, dayIndex, periodIndex],
        );
        batch.rawInsert(
          '''
          INSERT OR IGNORE INTO ${DbTables.timetable} (
            ${DbColumns.dayIndex},
            ${DbColumns.periodIndex},
            ${DbColumns.classId}
          )
          VALUES (?, ?, ?)
          ''',
          [dayIndex, periodIndex, classId],
        );
        await batch.commit(noResult: true);
      });
    }
  }
}
