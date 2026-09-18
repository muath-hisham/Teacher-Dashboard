import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/classes/presentation/providers/classes_providers.dart';
import 'package:teacher_dashboard/features/timetable/data/timetable_repository.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository(DatabaseHelper.instance);
});

class TimetableCellState {
  const TimetableCellState({
    required this.dayIndex,
    required this.periodIndex,
    this.classId,
    this.className,
  });

  final int dayIndex;
  final int periodIndex;
  final int? classId;
  final String? className;
}

/// Provides the full 7x4 grid state, mapped to class names.
final timetableGridProvider = FutureProvider<List<TimetableCellState>>((ref) async {
  final repo = ref.watch(timetableRepositoryProvider);
  final dbCells = await repo.getAll();
  final classes = await ref.watch(classesListProvider.future);

  final List<TimetableCellState> grid = [];
  
  for (int day = 0; day < 7; day++) {
    for (int period = 0; period < 4; period++) {
      final dbMatch = dbCells.where((c) => c.dayIndex == day && c.periodIndex == period).firstOrNull;
      
      int? classId;
      String? className;
      
      if (dbMatch != null) {
        classId = dbMatch.classId;
        className = classes.where((c) => c.id == classId).firstOrNull?.name;
      }
      
      grid.add(TimetableCellState(
        dayIndex: day,
        periodIndex: period,
        classId: classId,
        className: className,
      ));
    }
  }
  
  return grid;
});
