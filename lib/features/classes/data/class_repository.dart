import 'package:teacher_dashboard/core/database/database_constants.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/classes/domain/class_model.dart';

/// Data access for the [classes] table.
///
/// Every query uses parameterized args — no string interpolation.
class ClassRepository {
  ClassRepository(this._dbHelper);

  final DatabaseHelper _dbHelper;

  /// Returns all classes ordered by creation date (newest first),
  /// each including a [studentCount] via subquery.
  Future<List<ClassModel>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.rawQuery('''
      SELECT c.*,
             (SELECT COUNT(*)
              FROM ${DbTables.students} s
              WHERE s.${DbColumns.classId} = c.${DbColumns.id}
             ) AS student_count
      FROM ${DbTables.classes} c
      ORDER BY c.${DbColumns.createdAt} DESC, c.${DbColumns.id} DESC
    ''');
    return rows.map(ClassModel.fromMap).toList();
  }

  /// Returns a single class by [id], or `null` if not found.
  Future<ClassModel?> getById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.rawQuery('''
      SELECT c.*,
             (SELECT COUNT(*)
              FROM ${DbTables.students} s
              WHERE s.${DbColumns.classId} = c.${DbColumns.id}
             ) AS student_count
      FROM ${DbTables.classes} c
      WHERE c.${DbColumns.id} = ?
    ''', [id]);
    if (rows.isEmpty) return null;
    return ClassModel.fromMap(rows.first);
  }

  /// Inserts a new class and returns its row id.
  Future<int> insert(String name) async {
    final db = await _dbHelper.database;
    return db.insert(
      DbTables.classes,
      {DbColumns.name: name.trim()},
    );
  }

  /// Renames a class.
  Future<void> rename(int id, String name) async {
    final db = await _dbHelper.database;
    await db.update(
      DbTables.classes,
      {DbColumns.name: name.trim()},
      where: '${DbColumns.id} = ?',
      whereArgs: [id],
    );
  }

  /// Deletes a class. CASCADE removes its students, sessions, and attendance.
  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DbTables.classes,
      where: '${DbColumns.id} = ?',
      whereArgs: [id],
    );
  }
}
