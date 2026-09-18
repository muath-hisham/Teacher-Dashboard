import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_dashboard/features/backup/data/backup_validator.dart';

void main() {
  group('BackupValidator', () {
    test('Valid backup passes validation', () {
      final validData = {
        'classes': [
          {'id': 1, 'name': 'Math 101', 'created_at': '2023-01-01T00:00:00.000'}
        ],
        'students': [
          {
            'id': 1,
            'class_id': 1,
            'name': 'John Doe',
            'phone': '1234567890',
            'guardian_phone': null,
            'created_at': '2023-01-01T00:00:00.000'
          }
        ],
        'sessions': [
          {'id': 1, 'class_id': 1, 'title': 'Week 1', 'date': '2023-01-02T00:00:00.000', 'start_time': null, 'created_at': '2023-01-02T00:00:00.000'}
        ],
        'attendance': [
          {'id': 1, 'session_id': 1, 'student_id': 1, 'status': 'present', 'note': null}
        ],
        'notes': [
          {'id': 1, 'class_id': 1, 'body': 'Good class', 'created_at': '2023-01-02T00:00:00.000'}
        ],
        'timetable': [
          {'id': 1, 'day_index': 0, 'period_index': 0, 'class_id': 1}
        ],
      };

      expect(() => BackupValidator.validate(validData), returnsNormally);
    });

    test('Missing array throws exception', () {
      final invalidData = {
        'classes': [],
        // Missing others
      };

      expect(
        () => BackupValidator.validate(invalidData),
        throwsA(isA<BackupValidationException>().having(
            (e) => e.message, 'message', contains('Missing array'))),
      );
    });

    test('Invalid attendance status throws exception', () {
      final invalidData = {
        'classes': [],
        'students': [],
        'sessions': [],
        'attendance': [
          {'id': 1, 'session_id': 1, 'student_id': 1, 'status': 'unknown_status', 'note': null}
        ],
        'notes': [],
        'timetable': [],
      };

      expect(
        () => BackupValidator.validate(invalidData),
        throwsA(isA<BackupValidationException>().having(
            (e) => e.message, 'message', contains('Invalid status'))),
      );
    });
    
    test('Wrong data type throws exception', () {
      final invalidData = {
        'classes': [
          {'id': '1', 'name': 'Math 101', 'created_at': '2023-01-01T00:00:00.000'} // id should be int
        ],
        'students': [],
        'sessions': [],
        'attendance': [],
        'notes': [],
        'timetable': [],
      };

      expect(
        () => BackupValidator.validate(invalidData),
        throwsA(isA<BackupValidationException>().having(
            (e) => e.message, 'message', contains('must be of type int'))),
      );
    });
  });
}
