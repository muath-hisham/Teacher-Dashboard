import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_status.dart';
import 'package:teacher_dashboard/features/reports/presentation/providers/reports_providers.dart';

class StudentReportScreen extends ConsumerWidget {
  const StudentReportScreen({
    super.key,
    required this.studentId,
  });

  final int studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final dateRange = ref.watch(reportDateRangeProvider);
    
    final filter = ReportFilter(
      id: studentId,
      startDate: dateRange?.start,
      endDate: dateRange?.end,
    );
    
    final reportAsync = ref.watch(studentReportProvider(filter));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.studentReport),
      ),
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (report) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                report.studentName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (dateRange != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${DateFormat.yMMMd().format(dateRange.start)} - ${DateFormat.yMMMd().format(dateRange.end)}',
                  style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
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
                l10n.statusBreakdown,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (report.totalSessions == 0)
                Text(
                  l10n.noNotesSubtitle, // Resusing a generic string, or we could add a new one
                  style: TextStyle(color: colors.textSecondary),
                )
              else ...[
                // Percentage Bars
                _PercentageBar(
                  label: l10n.statusPresent,
                  count: report.statusBreakdown[AttendanceStatus.present] ?? 0,
                  total: report.totalSessions,
                  color: colors.present,
                ),
                const SizedBox(height: 8),
                _PercentageBar(
                  label: l10n.statusLate,
                  count: report.statusBreakdown[AttendanceStatus.late] ?? 0,
                  total: report.totalSessions,
                  color: colors.late,
                ),
                const SizedBox(height: 8),
                _PercentageBar(
                  label: l10n.statusExcused,
                  count: report.statusBreakdown[AttendanceStatus.excused] ?? 0,
                  total: report.totalSessions,
                  color: colors.excused,
                ),
                const SizedBox(height: 8),
                _PercentageBar(
                  label: l10n.statusAbsent,
                  count: report.statusBreakdown[AttendanceStatus.absent] ?? 0,
                  total: report.totalSessions,
                  color: colors.absent,
                ),
              ],
              const SizedBox(height: 32),
              Text(
                l10n.sessionHistory,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (report.history.isEmpty)
                Text(
                  l10n.noNotesSubtitle, // Reusing generic string
                  style: TextStyle(color: colors.textSecondary),
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
                    itemCount: report.history.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final h = report.history[i];
                      final isAbsent = h.status == AttendanceStatus.absent;
                      
                      return ListTile(
                        title: Text(h.sessionTitle),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(DateFormat.yMMMd().format(h.date)),
                            if (h.note != null && h.note!.isNotEmpty)
                              Text(h.note!, style: const TextStyle(fontStyle: FontStyle.italic)),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isAbsent ? colors.absent.withAlpha(20) : colors.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isAbsent ? colors.absent.withAlpha(100) : colors.border,
                            ),
                          ),
                          child: Text(
                            h.status.label(l10n),
                            style: TextStyle(
                              color: isAbsent ? colors.absent : colors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
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

class _PercentageBar extends StatelessWidget {
  const _PercentageBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final percentage = total > 0 ? (count / total) : 0.0;
    
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 50,
          child: Text(
            '$count (${(percentage * 100).toInt()}%)',
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
