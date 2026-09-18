import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/features/classes/presentation/providers/classes_providers.dart';
import 'package:teacher_dashboard/features/reports/presentation/providers/reports_providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  int? _selectedClassId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final classesAsync = ref.watch(classesListProvider);
    final dateRange = ref.watch(reportDateRangeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reports),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range_rounded),
            onPressed: _pickDateRange,
          ),
        ],
      ),
      body: classesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (classes) {
          if (classes.isEmpty) {
            return Center(
              child: Text(
                l10n.noClassesSubtitle,
                style: TextStyle(color: colors.textSecondary),
              ),
            );
          }

          // Auto-select first class if none selected
          if (_selectedClassId == null && classes.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _selectedClassId = classes.first.id);
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filters
              Container(
                padding: const EdgeInsets.all(16),
                color: colors.surfaceVariant,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButton<int>(
                      value: _selectedClassId ?? classes.first.id,
                      isExpanded: true,
                      dropdownColor: colors.surface,
                      items: classes.map((c) {
                        return DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedClassId = val);
                      },
                    ),
                    if (dateRange != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${DateFormat.yMMMd().format(dateRange.start)} - ${DateFormat.yMMMd().format(dateRange.end)}',
                            style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              ref.read(reportDateRangeProvider.notifier).state = null;
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Report Body
              if (_selectedClassId != null)
                Expanded(
                  child: _ClassReportView(
                    classId: _selectedClassId!,
                    dateRange: dateRange,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: ref.read(reportDateRangeProvider) != null
          ? DateTimeRange(
              start: ref.read(reportDateRangeProvider)!.start,
              end: ref.read(reportDateRangeProvider)!.end,
            )
          : null,
    );
    if (range != null) {
      ref.read(reportDateRangeProvider.notifier).state = ReportDateRange(
        start: range.start,
        end: range.end,
      );
    }
  }
}

class _ClassReportView extends ConsumerWidget {
  const _ClassReportView({
    required this.classId,
    required this.dateRange,
  });

  final int classId;
  final ReportDateRange? dateRange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    
    final filter = ReportFilter(
      id: classId,
      startDate: dateRange?.start,
      endDate: dateRange?.end,
    );
    
    final reportAsync = ref.watch(classReportProvider(filter));

    return reportAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (report) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: l10n.attendanceRate,
                    value: report.attendanceRate != null 
                        ? '${(report.attendanceRate! * 100).toStringAsFixed(1)}%' 
                        : '—',
                    icon: Icons.percent_rounded,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: l10n.totalSessions,
                    value: '${report.totalSessions}',
                    icon: Icons.calendar_month_rounded,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              l10n.studentRankings,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (report.studentRankings.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.noStudentsTitle,
                  style: TextStyle(color: colors.textSecondary),
                ),
              )
            else
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colors.border),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: report.studentRankings.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final rank = report.studentRankings[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: rank.absences > 0 
                            ? colors.absent.withAlpha(30) 
                            : colors.present.withAlpha(30),
                        child: Text(
                          '${rank.absences}',
                          style: TextStyle(
                            color: rank.absences > 0 ? colors.absent : colors.present,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(rank.studentName),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        context.go('/reports/student/${rank.studentId}');
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
