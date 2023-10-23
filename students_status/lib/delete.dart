import 'package:students_status/sqldb.dart';

class Delete {
  static SqlDb _sqlDb = SqlDb();
  static Future<bool> deleteAttendanceFromStudent(int id) async {
    int i =
        await _sqlDb.deleteData("DELETE FROM attendance WHERE student_id = $id");
    if (i == 0) {
      return false;
    }
    return true;
  }

  static Future<bool> deleteAttendanceFromLesson(int id) async {
    int i =
        await _sqlDb.deleteData("DELETE FROM attendance WHERE lesson_id = $id");
    if (i == 0) {
      return false;
    }
    return true;
  }

  static Future<bool> deleteStudent(int id) async {
    deleteAttendanceFromStudent(id);
    int i =
        await _sqlDb.deleteData("DELETE FROM students WHERE student_id = $id");
    if (i == 0) {
      return false;
    }
    return true;
  }

  static Future<bool> deleteLesson(int id) async {
    deleteAttendanceFromLesson(id);
    int i = await _sqlDb.deleteData("DELETE FROM lesson WHERE lesson_id = $id");
    if (i == 0) {
      return false;
    }
    return true;
  }

  static Future<bool> deleteLevel(int id) async {
    List<Map> lessons =
        await _sqlDb.readData("SELECT * FROM lesson WHERE level_id = $id");
    for (Map lesson in lessons) {
      deleteLesson(lesson['lesson_id']);
    }
    List<Map> students =
        await _sqlDb.readData("SELECT * FROM students WHERE level_id = $id");
    for (Map student in students) {
      deleteStudent(student['student_id']);
    }
    int i = await _sqlDb.deleteData("DELETE FROM level WHERE level_id = $id");
    if (i == 0) {
      return false;
    }
    return true;
  }
}
