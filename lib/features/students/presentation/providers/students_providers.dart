import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/core/utils/arabic_normalizer.dart';
import 'package:teacher_dashboard/features/students/data/student_repository.dart';
import 'package:teacher_dashboard/features/students/domain/student_model.dart';

/// Singleton [StudentRepository] provider.
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository(DatabaseHelper.instance);
});

/// Reactive list of students for a given [classId].
///
/// Call `ref.invalidate(studentsListProvider(classId))` after mutations.
final studentsListProvider =
    FutureProvider.family<List<StudentModel>, int>((ref, classId) async {
  final repo = ref.watch(studentRepositoryProvider);
  return repo.getByClassId(classId);
});

/// The current search query for student filtering, keyed by [classId].
final studentSearchQueryProvider =
    StateProvider.family<String, int>((ref, classId) => '');

/// Students filtered by the search query using Arabic normalization.
///
/// Reads the full student list and filters in Dart so that Arabic
/// letter variants, diacritics, and tatweel are handled correctly.
final filteredStudentsProvider =
    Provider.family<AsyncValue<List<StudentModel>>, int>((ref, classId) {
  final studentsAsync = ref.watch(studentsListProvider(classId));
  final query = ref.watch(studentSearchQueryProvider(classId)).trim();

  return studentsAsync.whenData((students) {
    if (query.isEmpty) return students;
    return students
        .where((s) => ArabicNormalizer.containsNormalized(s.name, query))
        .toList();
  });
});
