import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teacher_dashboard/core/database/database_constants.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/backup/data/backup_validator.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(DatabaseHelper.instance);
});

class BackupService {
  BackupService(this._dbHelper);

  final DatabaseHelper _dbHelper;

  static const _tablesInFkSafeOrder = [
    DbTables.classes,
    DbTables.students,
    DbTables.sessions,
    DbTables.attendance,
    DbTables.notes,
    DbTables.timetable,
  ];

  Future<void> exportDatabase() async {
    final db = await _dbHelper.database;
    final Map<String, List<Map<String, dynamic>>> dump = {};

    for (final table in _tablesInFkSafeOrder) {
      dump[table] = await db.query(table);
    }

    final jsonString = jsonEncode(dump);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/teacher_dashboard_backup.json');
    await file.writeAsString(jsonString);

    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Teacher Dashboard Backup',
      ),
    );
    
    if (result.status == ShareResultStatus.unavailable) {
      throw Exception('Share sheet is unavailable on this device.');
    }
  }

  Future<void> importDatabase() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) {
      return; // User cancelled
    }

    final file = File(result.files.first.path!);
    final jsonString = await file.readAsString();
    
    dynamic decoded;
    try {
      decoded = jsonDecode(jsonString);
    } catch (e) {
      throw BackupValidationException("Invalid JSON format.");
    }
    
    if (decoded is! Map<String, dynamic>) {
      throw const BackupValidationException("Root must be a JSON object.");
    }

    // Validate the parsed structure
    BackupValidator.validate(decoded);

    // If we passed validation, perform atomic transactional replacement
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      
      // 1. Delete in reverse FK-safe order
      for (final table in _tablesInFkSafeOrder.reversed) {
        batch.delete(table);
      }
      
      // 2. Insert in FK-safe order
      for (final table in _tablesInFkSafeOrder) {
        final rows = decoded[table] as List;
        for (final row in rows) {
          batch.insert(table, row as Map<String, dynamic>);
        }
      }
      
      await batch.commit(noResult: true);
    });
  }
}
