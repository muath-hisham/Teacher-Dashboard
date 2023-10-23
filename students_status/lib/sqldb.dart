import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    _db ??= await intialDb();
    return _db;
  }

  Database? get dbPrivate => _db;

  intialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'elmared.db'); // name of database
    Database mydb = await openDatabase(path, onCreate: _onCreate, version: 1);
    return mydb;
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
      CREATE TABLE 'level' (
        'level_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'name' TEXT 
      )
    ''');

    batch.execute('''
      CREATE TABLE 'lesson' (
        'lesson_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'name' TEXT,
        'link' TEXT,
        'level_id' INTEGER,
        FOREIGN KEY (level_id) REFERENCES level (level_id)                  
        ON DELETE NO ACTION ON UPDATE NO ACTION
      )
    ''');

    batch.execute('''
      CREATE TABLE 'students' (
        'student_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'name' TEXT,
        'phone' TEXT,
        'level_id' INTEGER,
        FOREIGN KEY (level_id) REFERENCES level (level_id)                  
        ON DELETE NO ACTION ON UPDATE NO ACTION
      )
    ''');

    batch.execute('''
      CREATE TABLE 'attendance' (
        'attendance_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'student_id' INTEGER,
        'lesson_id' INTEGER,
        FOREIGN KEY (student_id) REFERENCES students (student_id)                  
        ON DELETE NO ACTION ON UPDATE NO ACTION,
        FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id)                  
        ON DELETE NO ACTION ON UPDATE NO ACTION
      )
    ''');

    batch.execute('''
      CREATE TABLE 'schedule' (
        'id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'first' TEXT,
        'second' TEXT,
        'third' TEXT,
        'fourth' TEXT
      )
    ''');

    batch.execute('''
      CREATE TABLE 'notes' (
        'id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'name' TEXT,
        'note' TEXT
      )
    ''');
    await batch.commit();
    print("db created ===============================");
  }

  Future<List<Map>> readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  Future<int> insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  Future<int> updateData(String sql, List<Object> list) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql, list);
    return response;
  }

  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<int> deleteAll(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.delete(sql);
    return response;
  }

  deleteDataBase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'elmared.db'); // name of database
    await deleteDatabase(path);
    print("deleted success");
    _db = await intialDb();
  }

  Future<void> insertLevels(List<dynamic>? levels) async {
    Database? mydb = await db;
    if (levels!.isNotEmpty) {
      for (var level in levels) {
        await mydb!.insert("level", level,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<void> insertLessons(List<dynamic>? lessons) async {
    Database? mydb = await db;
    if (lessons!.isNotEmpty) {
      for (var lesson in lessons) {
        await mydb!.insert("lesson", lesson,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<void> insertStudents(List<dynamic>? students) async {
    Database? mydb = await db;
    if (students!.isNotEmpty) {
      for (var student in students) {
        await mydb!.insert("students", student,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<void> insertAttendances(List<dynamic>? attendances) async {
    Database? mydb = await db;
    if (attendances!.isNotEmpty) {
      for (var attendance in attendances) {
        await mydb!.insert("attendance", attendance,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<void> insertSchedule(List<dynamic>? schedule) async {
    Database? mydb = await db;
    if (schedule!.isNotEmpty) {
      for (var item in schedule) {
        await mydb!.insert("schedule", item,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<void> insertNotes(List<dynamic>? notes) async {
    Database? mydb = await db;
    if (notes!.isNotEmpty) {
      for (var item in notes) {
        await mydb!.insert("notes", item,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }
}
