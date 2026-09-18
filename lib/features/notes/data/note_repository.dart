import 'package:teacher_dashboard/core/database/database_constants.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/notes/domain/note_model.dart';

class NoteRepository {
  NoteRepository(this._dbHelper);

  final DatabaseHelper _dbHelper;

  Future<List<NoteModel>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DbTables.notes,
      orderBy: '${DbColumns.createdAt} DESC',
    );
    return rows.map(NoteModel.fromMap).toList();
  }

  Future<List<NoteModel>> getByClassId(int classId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DbTables.notes,
      where: '${DbColumns.classId} = ?',
      whereArgs: [classId],
      orderBy: '${DbColumns.createdAt} DESC',
    );
    return rows.map(NoteModel.fromMap).toList();
  }

  Future<void> insert(NoteModel note) async {
    final db = await _dbHelper.database;
    await db.insert(DbTables.notes, note.toMap());
  }

  Future<void> update(NoteModel note) async {
    final db = await _dbHelper.database;
    await db.update(
      DbTables.notes,
      note.toMap(),
      where: '${DbColumns.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DbTables.notes,
      where: '${DbColumns.id} = ?',
      whereArgs: [id],
    );
  }
}
