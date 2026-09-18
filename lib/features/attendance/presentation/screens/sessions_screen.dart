import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/features/attendance/presentation/providers/sessions_providers.dart';
import 'package:teacher_dashboard/features/attendance/presentation/screens/session_form_sheet.dart';
import 'package:teacher_dashboard/features/classes/presentation/providers/classes_providers.dart';

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key, required this.classId});

  final int classId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final sessionsAsync = ref.watch(sessionsListProvider(classId));
    final classAsync = ref.watch(classesListProvider);

    final className = classAsync.whenOrNull(
      data: (list) {
        final match = list.where((c) => c.id == classId);
        return match.isNotEmpty ? match.first.name : null;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(className == null ? l10n.sessions : '$className - ${l10n.sessions}'),
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (sessions) {
          if (sessions.isEmpty) {
            return _EmptySessionsState(
              onAdd: () => _showAddSession(context, ref),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
            itemCount: sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final session = sessions[index];
              return Card(
                child: InkWell(
                  onTap: () => context.go('/classes/$classId/sessions/${session.id}/attendance'),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.event_available_rounded,
                            color: colors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded, size: 14, color: colors.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(session.date, style: Theme.of(context).textTheme.bodySmall),
                                  const SizedBox(width: 12),
                                  Icon(Icons.access_time_rounded, size: 14, color: colors.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(session.startTime, style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                              if (session.link != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.link_rounded, size: 14, color: colors.primary),
                                    const SizedBox(width: 4),
                                    Text('Link available', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.primary)),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_rounded, color: colors.textSecondary),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditSession(context, ref, session);
                            } else if (value == 'delete') {
                              _deleteSession(context, ref, session.id);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_rounded, size: 20, color: colors.textSecondary),
                                  const SizedBox(width: 12),
                                  Text(l10n.edit),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline_rounded, size: 20, color: colors.absent),
                                  const SizedBox(width: 12),
                                  Text(l10n.delete, style: TextStyle(color: colors.absent)),
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
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSession(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addSession),
      ),
    );
  }

  void _showAddSession(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SessionFormSheet(
          classId: classId,
          onSaved: () => ref.invalidate(sessionsListProvider(classId)),
        );
      },
    );
  }

  void _showEditSession(BuildContext context, WidgetRef ref, dynamic session) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SessionFormSheet(
          classId: classId,
          session: session,
          onSaved: () => ref.invalidate(sessionsListProvider(classId)),
        );
      },
    );
  }

  Future<void> _deleteSession(BuildContext context, WidgetRef ref, int sessionId) async {
    final l10n = context.l10n;
    final colors = context.colors;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.deleteSessionConfirmTitle),
          content: Text(l10n.deleteSessionConfirmBody),
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
        await ref.read(sessionRepositoryProvider).delete(sessionId);
        ref.invalidate(sessionsListProvider(classId));
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }
}

class _EmptySessionsState extends StatelessWidget {
  const _EmptySessionsState({required this.onAdd});

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
                  Icons.event_note_rounded,
                  size: 44,
                  color: colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noSessionsTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noSessionsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addSession),
            ),
          ],
        ),
      ),
    );
  }
}
