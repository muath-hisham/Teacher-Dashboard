import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/classes/presentation/providers/classes_providers.dart';
import 'package:teacher_dashboard/features/notes/data/note_repository.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository(DatabaseHelper.instance);
});

class NoteItemState {
  const NoteItemState({
    required this.id,
    required this.body,
    required this.createdAt,
    this.classId,
    this.className,
  });

  final int id;
  final String body;
  final DateTime createdAt;
  final int? classId;
  final String? className;
}

/// Provides all notes, merging them with class names.
final notesListProvider = FutureProvider<List<NoteItemState>>((ref) async {
  final notes = await ref.watch(noteRepositoryProvider).getAll();
  
  // If classes haven't loaded yet, we'll just not show names temporarily,
  // or we can await it. We can await it since it's a FutureProvider.
  // Wait, classesListProvider is a FutureProvider. So we should await ref.watch(classesListProvider.future);
  final classes = await ref.watch(classesListProvider.future);

  return notes.map((note) {
    final className = note.classId != null 
        ? classes.where((c) => c.id == note.classId).firstOrNull?.name 
        : null;
        
    return NoteItemState(
      id: note.id!,
      body: note.body,
      createdAt: note.createdAt ?? DateTime.now(),
      classId: note.classId,
      className: className,
    );
  }).toList();
});
