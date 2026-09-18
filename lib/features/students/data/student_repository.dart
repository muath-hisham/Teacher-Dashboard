import 'package:teacher_dashboard/core/database/database_constants.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/students/domain/student_model.dart';

/// Data access for the [students] table.
///
/// Every query uses parameterized args — no string interpolation.
class StudentRepository {
  StudentRepository(this._dbHelper);

  final DatabaseHelper _dbHelper;

  /// Returns all students for [classId], ordered by name.
  Future<List<StudentModel>> getByClassId(int classId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DbTables.students,
      where: '${DbColumns.classId} = ?',
      whereArgs: [classId],
      orderBy: DbColumns.name,
    );
    return rows.map(StudentModel.fromMap).toList();
  }

  /// Returns a single student by [id], or `null` if not found.
  Future<StudentModel?> getById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DbTables.students,
      where: '${DbColumns.id} = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return StudentModel.fromMap(rows.first);
  }

  /// Inserts a new student and returns its row id.
  Future<int> insert({
    required int classId,
    required String name,
    String? phone,
    String? guardianPhone,
  }) async {
    final db = await _dbHelper.database;
    return db.insert(DbTables.students, {
      DbColumns.classId: classId,
      DbColumns.name: name.trim(),
      DbColumns.phone: phone,
      DbColumns.guardianPhone: guardianPhone,
    });
  }

  /// Updates an existing student.
  Future<void> update({
    required int id,
    required String name,
    String? phone,
    String? guardianPhone,
  }) async {
    final db = await _dbHelper.database;
    await db.update(
      DbTables.students,
      {
        DbColumns.name: name.trim(),
        DbColumns.phone: phone,
        DbColumns.guardianPhone: guardianPhone,
      },
      where: '${DbColumns.id} = ?',
      whereArgs: [id],
    );
  }

  /// Deletes a student. CASCADE removes their attendance records.
  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DbTables.students,
      where: '${DbColumns.id} = ?',
      whereArgs: [id],
    );
  }
}
