import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/classes/data/class_repository.dart';
import 'package:teacher_dashboard/features/classes/domain/class_model.dart';

/// Singleton [ClassRepository] provider.
final classRepositoryProvider = Provider<ClassRepository>((ref) {
  return ClassRepository(DatabaseHelper.instance);
});

/// Reactive list of all classes with student counts.
///
/// Call `ref.invalidate(classesListProvider)` after any mutation
/// to trigger a reload.
final classesListProvider = FutureProvider<List<ClassModel>>((ref) async {
  final repo = ref.watch(classRepositoryProvider);
  return repo.getAll();
});
