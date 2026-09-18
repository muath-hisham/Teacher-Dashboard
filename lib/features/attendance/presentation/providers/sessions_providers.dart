import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/attendance/data/session_repository.dart';
import 'package:teacher_dashboard/features/attendance/domain/session_model.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(DatabaseHelper.instance);
});

final sessionsListProvider =
    FutureProvider.family<List<SessionModel>, int>((ref, classId) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return repo.getByClassId(classId);
});
