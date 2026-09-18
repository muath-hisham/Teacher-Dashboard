/// Table and column name constants to avoid typos in queries.
abstract final class DbTables {
  static const classes = 'classes';
  static const students = 'students';
  static const sessions = 'sessions';
  static const attendance = 'attendance';
  static const notes = 'notes';
  static const timetable = 'timetable';
}

/// Shared column names used across multiple tables.
abstract final class DbColumns {
  static const id = 'id';
  static const classId = 'class_id';
  static const name = 'name';
  static const createdAt = 'created_at';
  static const phone = 'phone';
  static const guardianPhone = 'guardian_phone';
  static const title = 'title';
  static const link = 'link';
  static const date = 'date';
  static const startTime = 'start_time';
  static const sessionId = 'session_id';
  static const studentId = 'student_id';
  static const status = 'status';
  static const note = 'note';
  static const body = 'body';
  static const dayIndex = 'day_index';
  static const periodIndex = 'period_index';
}
