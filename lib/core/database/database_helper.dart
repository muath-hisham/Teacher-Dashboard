import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'database_constants.dart';

/// Singleton helper for the app's SQLite database.
///
/// * FKs are enabled on every connection.
/// * All DDL lives in [_onCreate] — never string-interpolate user data.
/// * ON DELETE CASCADE on most FKs; notes.class_id uses ON DELETE SET NULL.
class DatabaseHelper {
  DatabaseHelper._();
  static final instance = DatabaseHelper._();

  static const _dbName = 'teacher_dashboard.db';
  static const _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  /// Enable foreign keys for every connection.
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Create all tables — version 1.
  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    batch.execute('''
      CREATE TABLE ${DbTables.classes} (
        ${DbColumns.id}        INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbColumns.name}      TEXT    NOT NULL,
        ${DbColumns.createdAt} TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    batch.execute('''
      CREATE TABLE ${DbTables.students} (
        ${DbColumns.id}            INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbColumns.classId}       INTEGER NOT NULL
            REFERENCES ${DbTables.classes}(${DbColumns.id}) ON DELETE CASCADE,
        ${DbColumns.name}          TEXT    NOT NULL,
        ${DbColumns.phone}         TEXT,
        ${DbColumns.guardianPhone} TEXT,
        ${DbColumns.createdAt}     TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    batch.execute('''
      CREATE TABLE ${DbTables.sessions} (
        ${DbColumns.id}        INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbColumns.classId}   INTEGER NOT NULL
            REFERENCES ${DbTables.classes}(${DbColumns.id}) ON DELETE CASCADE,
        ${DbColumns.title}     TEXT    NOT NULL,
        ${DbColumns.link}      TEXT,
        ${DbColumns.date}      TEXT    NOT NULL,
        ${DbColumns.startTime} TEXT    NOT NULL,
        ${DbColumns.createdAt} TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    batch.execute('''
      CREATE TABLE ${DbTables.attendance} (
        ${DbColumns.id}        INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbColumns.sessionId} INTEGER NOT NULL
            REFERENCES ${DbTables.sessions}(${DbColumns.id}) ON DELETE CASCADE,
        ${DbColumns.studentId} INTEGER NOT NULL
            REFERENCES ${DbTables.students}(${DbColumns.id}) ON DELETE CASCADE,
        ${DbColumns.status}    TEXT    NOT NULL
            CHECK(${DbColumns.status} IN ('present','absent','late','excused')),
        ${DbColumns.note}      TEXT,
        UNIQUE(${DbColumns.sessionId}, ${DbColumns.studentId})
      )
    ''');

    batch.execute('''
      CREATE TABLE ${DbTables.notes} (
        ${DbColumns.id}        INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbColumns.classId}   INTEGER
            REFERENCES ${DbTables.classes}(${DbColumns.id}) ON DELETE SET NULL,
        ${DbColumns.body}      TEXT    NOT NULL,
        ${DbColumns.createdAt} TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    batch.execute('''
      CREATE TABLE ${DbTables.timetable} (
        ${DbColumns.id}          INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbColumns.dayIndex}    INTEGER NOT NULL,
        ${DbColumns.periodIndex} INTEGER NOT NULL,
        ${DbColumns.classId}     INTEGER NOT NULL
            REFERENCES ${DbTables.classes}(${DbColumns.id}) ON DELETE CASCADE,
        UNIQUE(${DbColumns.dayIndex}, ${DbColumns.periodIndex})
      )
    ''');

    await batch.commit(noResult: true);
  }

  /// Convenience: close the database (useful for tests).
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
