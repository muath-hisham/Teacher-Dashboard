import 'package:teacher_dashboard/core/database/database_constants.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_status.dart';
import 'package:teacher_dashboard/features/reports/domain/report_models.dart';

class ReportRepository {
  ReportRepository(this._dbHelper);

  final DatabaseHelper _dbHelper;

  Future<ClassReportModel> getClassReport(
    int classId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;

    // Get class name
    final classRows = await db.query(
      DbTables.classes,
      where: '${DbColumns.id} = ?',
      whereArgs: [classId],
    );
    if (classRows.isEmpty) throw Exception('Class not found');
    final className = classRows.first[DbColumns.name] as String;

    String dateFilter = '';
    final List<Object?> args = [classId];
    if (startDate != null) {
      dateFilter += ' AND s.${DbColumns.date} >= ?';
      args.add('${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}');
    }
    if (endDate != null) {
      dateFilter += ' AND s.${DbColumns.date} <= ?';
      args.add('${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}');
    }

    // Total sessions
    final sessionCountRow = await db.rawQuery(
      'SELECT COUNT(${DbColumns.id}) as count FROM ${DbTables.sessions} s WHERE class_id = ?$dateFilter',
      args,
    );
    final totalSessions = SqfliteUtils.firstIntValue(sessionCountRow) ?? 0;

    // Attendance Rate (Presents / Total Records)
    final rateArgs = [...args];
    final rateRow = await db.rawQuery('''
      SELECT 
        COUNT(a.id) as total,
        SUM(CASE WHEN a.status = 'present' OR a.status = 'late' THEN 1 ELSE 0 END) as presents
      FROM ${DbTables.attendance} a
      JOIN ${DbTables.sessions} s ON a.session_id = s.id
      WHERE s.class_id = ?$dateFilter
      ''', rateArgs);

    int totalRecords = 0;
    int presents = 0;
    if (rateRow.isNotEmpty) {
      totalRecords =
          SqfliteUtils.firstIntValue([
            {'count': rateRow.first['total']},
          ]) ??
          0;
      presents =
          SqfliteUtils.firstIntValue([
            {'count': rateRow.first['presents']},
          ]) ??
          0;
    }
    final attendanceRate = totalRecords > 0 ? (presents / totalRecords) : null;

    // Student Rankings (by absences)
    final rankRow = await db.rawQuery('''
      SELECT 
        st.${DbColumns.id},
        st.${DbColumns.name},
        SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) as absences
      FROM ${DbTables.students} st
      LEFT JOIN (
        SELECT a.student_id, a.status 
        FROM ${DbTables.attendance} a
        JOIN ${DbTables.sessions} s ON a.session_id = s.${DbColumns.id}
        WHERE s.class_id = ? $dateFilter
      ) a ON a.student_id = st.${DbColumns.id}
      WHERE st.class_id = ?
      GROUP BY st.${DbColumns.id}
      ORDER BY absences DESC, st.${DbColumns.name} ASC
      ''', [...rateArgs, classId]);

    final rankings = rankRow.map((r) {
      return StudentAbsenceRank(
        studentId: r[DbColumns.id] as int,
        studentName: r[DbColumns.name] as String,
        absences: r['absences'] as int? ?? 0,
      );
    }).toList();

    return ClassReportModel(
      classId: classId,
      className: className,
      totalSessions: totalSessions,
      attendanceRate: attendanceRate,
      studentRankings: rankings,
    );
  }

  Future<StudentReportModel> getStudentReport(
    int studentId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;

    // Get student name
    final stRows = await db.query(
      DbTables.students,
      where: '${DbColumns.id} = ?',
      whereArgs: [studentId],
    );
    if (stRows.isEmpty) throw Exception('Student not found');
    final studentName = stRows.first[DbColumns.name] as String;

    String dateFilter = '';
    final List<Object?> args = [studentId];
    if (startDate != null) {
      dateFilter += ' AND s.${DbColumns.date} >= ?';
      args.add('${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}');
    }
    if (endDate != null) {
      dateFilter += ' AND s.${DbColumns.date} <= ?';
      args.add('${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}');
    }

    final historyRows = await db.rawQuery('''
      SELECT 
        a.session_id,
        s.title,
        s.date,
        a.status,
        a.note
      FROM ${DbTables.attendance} a
      JOIN ${DbTables.sessions} s ON a.session_id = s.${DbColumns.id}
      WHERE a.student_id = ?$dateFilter
      ORDER BY s.${DbColumns.date} DESC
      ''', args);

    int totalSessions = historyRows.length;
    final breakdown = <AttendanceStatus, int>{
      AttendanceStatus.present: 0,
      AttendanceStatus.absent: 0,
      AttendanceStatus.late: 0,
      AttendanceStatus.excused: 0,
    };

    final history = historyRows.map((r) {
      final status = AttendanceStatus.fromDb(r['status'] as String);
      breakdown[status] = (breakdown[status] ?? 0) + 1;

      return AttendanceSessionHistory(
        sessionId: r['session_id'] as int,
        sessionTitle: r['title'] as String,
        date: DateTime.parse(r['date'] as String),
        status: status,
        note: r['note'] as String?,
      );
    }).toList();

    final presentsAndLates =
        (breakdown[AttendanceStatus.present] ?? 0) +
        (breakdown[AttendanceStatus.late] ?? 0);
    final attendanceRate = totalSessions > 0
        ? (presentsAndLates / totalSessions)
        : null;

    return StudentReportModel(
      studentId: studentId,
      studentName: studentName,
      totalSessions: totalSessions,
      attendanceRate: attendanceRate,
      statusBreakdown: breakdown,
      history: history,
    );
  }
}

class SqfliteUtils {
  static int? firstIntValue(List<Map<String, Object?>> rows) {
    if (rows.isEmpty) return null;
    final val = rows.first.values.first;
    if (val is int) return val;
    if (val is String) return int.tryParse(val);
    return null;
  }
}
