import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/features/classes/presentation/providers/classes_providers.dart';
import 'package:teacher_dashboard/features/students/domain/student_model.dart';
import 'package:teacher_dashboard/features/students/presentation/providers/students_providers.dart';
import 'package:teacher_dashboard/features/students/presentation/screens/student_form_sheet.dart';
import 'package:teacher_dashboard/features/students/presentation/widgets/student_card.dart';

/// Shows the list of students in a class, with search and add.
class ClassDetailsScreen extends ConsumerStatefulWidget {
  const ClassDetailsScreen({super.key, required this.classId});

  final int classId;

  @override
  ConsumerState<ClassDetailsScreen> createState() =>
      _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends ConsumerState<ClassDetailsScreen> {
  bool _searching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searching = !_searching;
      if (!_searching) {
        _searchController.clear();
        ref.read(studentSearchQueryProvider(widget.classId).notifier).state = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final classAsync = ref.watch(classesListProvider);
    final studentsAsync =
        ref.watch(filteredStudentsProvider(widget.classId));

    // Derive class name from the loaded list
    final className = classAsync.whenOrNull(
      data: (list) {
        final match = list.where((c) => c.id == widget.classId);
        return match.isNotEmpty ? match.first.name : null;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.searchStudents,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  ref.read(studentSearchQueryProvider(widget.classId).notifier).state =
                      value;
                },
              )
            : Text(className ?? l10n.classDetailsScreenTitle),
        actions: [
          if (!_searching)
            IconButton(
              icon: const Icon(Icons.event_note_rounded),
              tooltip: l10n.sessions,
              onPressed: () => context.go('/classes/${widget.classId}/sessions'),
            ),
          IconButton(
            icon: Icon(
              _searching ? Icons.close_rounded : Icons.search_rounded,
            ),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: studentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (students) {
          if (students.isEmpty) {
            final query =
                ref.read(studentSearchQueryProvider(widget.classId)).trim();
            if (query.isNotEmpty) {
              // No search results
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 56, color: colors.textSecondary),
                    const SizedBox(height: 12),
                    Text(
                      l10n.noStudentsFoundTitle,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: colors.textSecondary,
                              ),
                    ),
                  ],
                ),
              );
            }
            return _EmptyStudentsState(
              onAdd: () => _showAddStudent(context),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
            itemCount: students.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final student = students[index];
              return StudentCard(
                student: student,
                onEdit: () => _showEditStudent(context, student),
                onDelete: () => _deleteStudent(student.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddStudent(context),
        icon: const Icon(Icons.person_add_rounded),
        label: Text(l10n.addStudent),
      ),
    );
  }

  void _showAddStudent(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StudentFormSheet(
          classId: widget.classId,
          onSaved: () {
            ref.invalidate(studentsListProvider(widget.classId));
            ref.invalidate(classesListProvider);
          },
        );
      },
    );
  }

  void _showEditStudent(BuildContext context, StudentModel student) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StudentFormSheet(
          classId: widget.classId,
          student: student,
          onSaved: () {
            ref.invalidate(studentsListProvider(widget.classId));
          },
        );
      },
    );
  }

  Future<void> _deleteStudent(int studentId) async {
    final l10n = context.l10n;
    final colors = context.colors;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.deleteStudentConfirmTitle),
          content: Text(l10n.deleteStudentConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colors.absent),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await ref.read(studentRepositoryProvider).delete(studentId);
        ref.invalidate(studentsListProvider(widget.classId));
        ref.invalidate(classesListProvider);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }
}

// ── Empty state ────────────────────────────────────────────────────

class _EmptyStudentsState extends StatelessWidget {
  const _EmptyStudentsState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary.withAlpha(30),
                      colors.primaryContainer,
                    ],
                  ),
                ),
                child: Icon(
                  Icons.person_add_rounded,
                  size: 44,
                  color: colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noStudentsTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noStudentsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addStudent),
            ),
          ],
        ),
      ),
    );
  }
}
