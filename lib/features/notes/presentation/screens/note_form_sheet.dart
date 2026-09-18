import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/features/classes/presentation/providers/classes_providers.dart';
import 'package:teacher_dashboard/features/notes/domain/note_model.dart';
import 'package:teacher_dashboard/features/notes/presentation/providers/notes_providers.dart';

class NoteFormSheet extends ConsumerStatefulWidget {
  const NoteFormSheet({
    super.key,
    this.note,
    required this.onSaved,
  });

  final NoteItemState? note;
  final VoidCallback onSaved;

  @override
  ConsumerState<NoteFormSheet> createState() => _NoteFormSheetState();
}

class _NoteFormSheetState extends ConsumerState<NoteFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bodyController;
  int? _selectedClassId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _bodyController = TextEditingController(text: widget.note?.body ?? '');
    _selectedClassId = widget.note?.classId;
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _saving = true);
    
    try {
      final repo = ref.read(noteRepositoryProvider);
      
      final newNote = NoteModel(
        id: widget.note?.id,
        classId: _selectedClassId,
        body: _bodyController.text.trim(),
        createdAt: widget.note?.createdAt,
      );
      
      if (widget.note == null) {
        await repo.insert(newNote);
      } else {
        await repo.update(newNote);
      }
      
      widget.onSaved();
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    if (widget.note == null) return;
    
    final l10n = context.l10n;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteNoteConfirmTitle),
        content: Text(l10n.deleteNoteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
    
    if (confirm != true || !mounted) return;

    setState(() => _saving = true);
    try {
      await ref.read(noteRepositoryProvider).delete(widget.note!.id);
      ref.invalidate(notesListProvider);
      widget.onSaved();
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final classesAsync = ref.watch(classesListProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.note == null 
                      ? l10n.addNote 
                      : l10n.editNote,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (widget.note != null)
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: colors.absent),
                    onPressed: _saving ? null : _delete,
                  ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Class Picker Dropdown
            classesAsync.when(
              data: (classes) {
                if (classes.isEmpty) return const SizedBox.shrink();
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DropdownButtonFormField<int?>(
                    initialValue: _selectedClassId,
                    decoration: InputDecoration(
                      labelText: l10n.attachToClass,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(l10n.none, style: TextStyle(color: colors.textSecondary)),
                      ),
                      ...classes.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name),
                      )),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedClassId = val);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(e.toString()),
            ),
            
            TextFormField(
              controller: _bodyController,
              autofocus: widget.note == null,
              maxLines: 5,
              minLines: 3,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                labelText: l10n.noteBody,
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return l10n.requiredField;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.save),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
