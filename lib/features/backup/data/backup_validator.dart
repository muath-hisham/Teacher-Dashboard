import 'package:teacher_dashboard/core/database/database_constants.dart';

/// Thrown when backup JSON schema validation fails.
class BackupValidationException implements Exception {
  const BackupValidationException(this.message);
  final String message;

  @override
  String toString() => 'BackupValidationException: $message';
}

/// Validates a backup JSON payload according to strict rules.
class BackupValidator {
  static void validate(Map<String, dynamic> data) {
    _checkArrayExists(data, DbTables.classes);
    _checkArrayExists(data, DbTables.students);
    _checkArrayExists(data, DbTables.sessions);
    _checkArrayExists(data, DbTables.attendance);
    _checkArrayExists(data, DbTables.notes);
    _checkArrayExists(data, DbTables.timetable);

    for (final row in data[DbTables.classes]) {
      _checkType<int>(row, DbColumns.id, 'classes');
      _checkType<String>(row, DbColumns.name, 'classes');
      _checkType<String>(row, DbColumns.createdAt, 'classes');
      _checkAllowedKeys(row, [DbColumns.id, DbColumns.name, DbColumns.createdAt], 'classes');
    }

    for (final row in data[DbTables.students]) {
      _checkType<int>(row, DbColumns.id, 'students');
      _checkType<int>(row, DbColumns.classId, 'students');
      _checkType<String>(row, DbColumns.name, 'students');
      _checkOptionalType<String>(row, DbColumns.phone, 'students');
      _checkOptionalType<String>(row, DbColumns.guardianPhone, 'students');
      _checkType<String>(row, DbColumns.createdAt, 'students');
      _checkAllowedKeys(row, [DbColumns.id, DbColumns.classId, DbColumns.name, DbColumns.phone, DbColumns.guardianPhone, DbColumns.createdAt], 'students');
    }

    for (final row in data[DbTables.sessions]) {
      _checkType<int>(row, DbColumns.id, 'sessions');
      _checkType<int>(row, DbColumns.classId, 'sessions');
      _checkType<String>(row, DbColumns.title, 'sessions');
      _checkType<String>(row, DbColumns.date, 'sessions');
      _checkOptionalType<String>(row, DbColumns.startTime, 'sessions');
      _checkType<String>(row, DbColumns.createdAt, 'sessions');
      _checkAllowedKeys(row, [DbColumns.id, DbColumns.classId, DbColumns.title, DbColumns.date, DbColumns.startTime, DbColumns.createdAt], 'sessions');
    }

    for (final row in data[DbTables.attendance]) {
      _checkType<int>(row, DbColumns.id, 'attendance');
      _checkType<int>(row, DbColumns.sessionId, 'attendance');
      _checkType<int>(row, DbColumns.studentId, 'attendance');
      final status = _checkType<String>(row, DbColumns.status, 'attendance');
      if (status != 'present' && status != 'absent' && status != 'late' && status != 'excused') {
        throw BackupValidationException("Invalid status in attendance: $status");
      }
      _checkOptionalType<String>(row, DbColumns.note, 'attendance');
      _checkAllowedKeys(row, [DbColumns.id, DbColumns.sessionId, DbColumns.studentId, DbColumns.status, DbColumns.note], 'attendance');
    }

    for (final row in data[DbTables.notes]) {
      _checkType<int>(row, DbColumns.id, 'notes');
      _checkOptionalType<int>(row, DbColumns.classId, 'notes');
      _checkType<String>(row, DbColumns.body, 'notes');
      _checkType<String>(row, DbColumns.createdAt, 'notes');
      _checkAllowedKeys(row, [DbColumns.id, DbColumns.classId, DbColumns.body, DbColumns.createdAt], 'notes');
    }

    for (final row in data[DbTables.timetable]) {
      _checkType<int>(row, DbColumns.id, 'timetable');
      _checkType<int>(row, DbColumns.dayIndex, 'timetable');
      _checkType<int>(row, DbColumns.periodIndex, 'timetable');
      _checkType<int>(row, DbColumns.classId, 'timetable');
      _checkAllowedKeys(row, [DbColumns.id, DbColumns.dayIndex, DbColumns.periodIndex, DbColumns.classId], 'timetable');
    }
  }

  static void _checkArrayExists(Map<String, dynamic> data, String key) {
    if (!data.containsKey(key)) {
      throw BackupValidationException("Missing array: $key");
    }
    if (data[key] is! List) {
      throw BackupValidationException("Key '$key' must be an array");
    }
  }

  static T _checkType<T>(dynamic row, String key, String table) {
    if (row is! Map) {
      throw BackupValidationException("Row in $table is not an object");
    }
    if (!row.containsKey(key)) {
      throw BackupValidationException("Missing field '$key' in $table row");
    }
    final val = row[key];
    if (val is! T) {
      throw BackupValidationException("Field '$key' in $table must be of type $T, got ${val.runtimeType}");
    }
    return val;
  }
  
  static T? _checkOptionalType<T>(dynamic row, String key, String table) {
    if (row is! Map) {
      throw BackupValidationException("Row in $table is not an object");
    }
    if (!row.containsKey(key)) {
      return null; // Optional can be completely missing
    }
    final val = row[key];
    if (val == null) return null;
    
    if (val is! T) {
      throw BackupValidationException("Field '$key' in $table must be of type $T, got ${val.runtimeType}");
    }
    return val;
  }
  
  static void _checkAllowedKeys(dynamic row, List<String> allowedKeys, String table) {
    if (row is! Map) return;
    for (final key in row.keys) {
      if (!allowedKeys.contains(key)) {
        throw BackupValidationException("Disallowed field '$key' in $table row");
      }
    }
  }
}
