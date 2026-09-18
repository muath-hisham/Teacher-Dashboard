import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_dashboard/core/constants/app_constants.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/core/l10n/app_localizations.dart';
import 'package:teacher_dashboard/features/classes/presentation/providers/classes_providers.dart';

/// Home screen — list of all classes.
///
/// Supports: create, rename, delete with cascade warning.
/// Each card shows class name + student count.
class ClassesScreen extends ConsumerWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesAsync = ref.watch(classesListProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.classesScreenTitle),
      ),
      body: classesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (classes) {
          if (classes.isEmpty) {
            return _EmptyClassesState(
              onAdd: () => _showAddClassDialog(context, ref),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
            itemCount: classes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final cls = classes[index];
              return _ClassCard(
                name: cls.name,
                studentCount: cls.studentCount,
                onTap: () => context.go('/classes/${cls.id}'),
                onRename: () =>
                    _showRenameDialog(context, ref, cls.id, cls.name),
                onDelete: () =>
                    _showDeleteDialog(context, ref, cls.id, cls.name),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddClassDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addClass),
      ),
    );
  }

  void _showAddClassDialog(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.addClass),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              maxLength: AppConstants.maxNameLength,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.className,
                hintText: l10n.classNameHint,
              ),
              validator: (v) => _validateClassName(v, l10n),
              onFieldSubmitted: (_) {
                if (formKey.currentState!.validate()) {
                  _createClass(ctx, ref, controller.text);
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _createClass(ctx, ref, controller.text);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  void _showRenameDialog(
      BuildContext context, WidgetRef ref, int id, String currentName) {
    final l10n = context.l10n;
    final controller = TextEditingController(text: currentName);
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.rename),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              maxLength: AppConstants.maxNameLength,
              decoration: InputDecoration(
                labelText: l10n.className,
              ),
              validator: (v) => _validateClassName(v, l10n),
              onFieldSubmitted: (_) {
                if (formKey.currentState!.validate()) {
                  _renameClass(ctx, ref, id, controller.text);
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _renameClass(ctx, ref, id, controller.text);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, int id, String name) {
    final l10n = context.l10n;
    final colors = context.colors;

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.deleteClassConfirmTitle),
          content: Text(l10n.deleteClassConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colors.absent,
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  await ref.read(classRepositoryProvider).delete(id);
                  ref.invalidate(classesListProvider);
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createClass(
      BuildContext context, WidgetRef ref, String name) async {
    Navigator.pop(context);
    try {
      await ref.read(classRepositoryProvider).insert(name);
      ref.invalidate(classesListProvider);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _renameClass(
      BuildContext context, WidgetRef ref, int id, String name) async {
    Navigator.pop(context);
    try {
      await ref.read(classRepositoryProvider).rename(id, name);
      ref.invalidate(classesListProvider);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String? _validateClassName(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return l10n.classNameRequired;
    if (trimmed.length > AppConstants.maxNameLength) {
      return l10n.classNameTooLong;
    }
    // Reject control characters
    if (RegExp(r'[\x00-\x1F\x7F]').hasMatch(trimmed)) {
      return l10n.classNameRequired;
    }
    return null;
  }
}

// ── Class card ─────────────────────────────────────────────────────

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    required this.name,
    required this.studentCount,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  final String name;
  final int studentCount;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // ── Icon ──
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.class_rounded,
                  color: colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // ── Text ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline_rounded,
                          size: 14,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.studentCount(studentCount),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Actions ──
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colors.textSecondary,
                ),
                onSelected: (value) {
                  if (value == 'rename') {
                    onRename();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded,
                            size: 20, color: colors.textSecondary),
                        const SizedBox(width: 12),
                        Text(l10n.rename),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded,
                            size: 20, color: colors.absent),
                        const SizedBox(width: 12),
                        Text(
                          l10n.delete,
                          style: TextStyle(color: colors.absent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────

class _EmptyClassesState extends StatelessWidget {
  const _EmptyClassesState({required this.onAdd});

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
                  Icons.school_rounded,
                  size: 44,
                  color: colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noClassesTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noClassesSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addClass),
            ),
          ],
        ),
      ),
    );
  }
}
