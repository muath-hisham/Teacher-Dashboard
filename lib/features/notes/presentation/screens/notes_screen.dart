import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/features/notes/presentation/providers/notes_providers.dart';
import 'package:teacher_dashboard/features/notes/presentation/screens/note_form_sheet.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final notesAsync = ref.watch(notesListProvider);

    return Scaffold(
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Text(
                l10n.noNotesSubtitle,
                style: TextStyle(color: colors.textSecondary),
              ),
            );
          }
          
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final note = notes[index];
              return _NoteCardWidget(note: note);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showNoteForm(context, ref);
        },
        icon: const Icon(Icons.note_add_rounded),
        label: Text(l10n.addNote),
      ),
    );
  }

  void _showNoteForm(BuildContext context, WidgetRef ref, [NoteItemState? note]) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return NoteFormSheet(
          note: note,
          onSaved: () {
            ref.invalidate(notesListProvider);
          },
        );
      },
    );
  }
}

class _NoteCardWidget extends ConsumerWidget {
  const _NoteCardWidget({required this.note});

  final NoteItemState note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final dateStr = DateFormat.yMMMd().format(note.createdAt);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showNoteForm(context, ref, note);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateStr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                  ),
                  if (note.className != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer.withAlpha(50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        note.className!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                note.body,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNoteForm(BuildContext context, WidgetRef ref, NoteItemState note) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return NoteFormSheet(
          note: note,
          onSaved: () {
            ref.invalidate(notesListProvider);
          },
        );
      },
    );
  }
}
