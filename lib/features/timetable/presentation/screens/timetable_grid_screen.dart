import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/features/classes/presentation/providers/classes_providers.dart';
import 'package:teacher_dashboard/features/timetable/presentation/providers/timetable_providers.dart';

class TimetableGridScreen extends ConsumerWidget {
  const TimetableGridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final gridAsync = ref.watch(timetableGridProvider);

    return gridAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (grid) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Table(
            border: TableBorder.all(
              color: colors.border,
              borderRadius: BorderRadius.circular(12),
            ),
            children: [
              // Header row
              TableRow(
                decoration: BoxDecoration(color: colors.surfaceVariant),
                children: [
                  const SizedBox(height: 48), // Empty top-left corner
                  for (int p = 0; p < 4; p++)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          'P${p + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // Day rows
              for (int d = 0; d < 7; d++)
                TableRow(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          _dayName(d, l10n),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    for (int p = 0; p < 4; p++)
                      _TimetableCellWidget(
                        cell: grid.firstWhere((c) => c.dayIndex == d && c.periodIndex == p),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  String _dayName(int dayIndex, dynamic l10n) {
    // We should probably add day names to ARB, but for now we'll do something simple.
    // Wait, Intl package has day names.
    // I will add them to ARB or just use basic for now.
    // Actually, I can add day strings to ARB.
    return [
      l10n.sunday,
      l10n.monday,
      l10n.tuesday,
      l10n.wednesday,
      l10n.thursday,
      l10n.friday,
      l10n.saturday,
    ][dayIndex];
  }
}

class _TimetableCellWidget extends ConsumerWidget {
  const _TimetableCellWidget({required this.cell});

  final TimetableCellState cell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    
    return InkWell(
      onTap: () => _pickClass(context, ref),
      child: Container(
        height: 64,
        padding: const EdgeInsets.all(4),
        color: cell.classId != null ? colors.primaryContainer.withAlpha(50) : null,
        child: Center(
          child: Text(
            cell.className ?? '-',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cell.classId != null ? colors.primary : colors.textSecondary,
              fontWeight: cell.classId != null ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Future<void> _pickClass(BuildContext context, WidgetRef ref) async {
    final classes = await ref.read(classesListProvider.future);
    
    if (!context.mounted) return;
    
    final l10n = context.l10n;
    final colors = context.colors;
    
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.assignClass,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (cell.classId != null) ...[
                ListTile(
                  leading: Icon(Icons.clear_rounded, color: colors.absent),
                  title: Text(l10n.clear, style: TextStyle(color: colors.absent)),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await ref.read(timetableRepositoryProvider).setCell(
                      cell.dayIndex,
                      cell.periodIndex,
                      null,
                    );
                    ref.invalidate(timetableGridProvider);
                  },
                ),
                const Divider(),
              ],
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: classes.length,
                  itemBuilder: (_, i) {
                    final c = classes[i];
                    return ListTile(
                      leading: Icon(Icons.class_rounded, color: colors.primary),
                      title: Text(c.name),
                      onTap: () async {
                        Navigator.pop(ctx);
                        await ref.read(timetableRepositoryProvider).setCell(
                          cell.dayIndex,
                          cell.periodIndex,
                          c.id,
                        );
                        ref.invalidate(timetableGridProvider);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
