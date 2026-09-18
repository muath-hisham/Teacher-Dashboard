import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/database/database_helper.dart';
import 'package:teacher_dashboard/features/reports/data/report_repository.dart';
import 'package:teacher_dashboard/features/reports/domain/report_models.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(DatabaseHelper.instance);
});

class ReportFilter {
  const ReportFilter({
    required this.id,
    this.startDate,
    this.endDate,
  });
  
  final int id;
  final DateTime? startDate;
  final DateTime? endDate;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportFilter &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          startDate == other.startDate &&
          endDate == other.endDate;
          
  @override
  int get hashCode => id.hashCode ^ startDate.hashCode ^ endDate.hashCode;
}

final classReportProvider = FutureProvider.family<ClassReportModel, ReportFilter>((ref, filter) {
  return ref.watch(reportRepositoryProvider).getClassReport(
    filter.id,
    startDate: filter.startDate,
    endDate: filter.endDate,
  );
});

final studentReportProvider = FutureProvider.family<StudentReportModel, ReportFilter>((ref, filter) {
  return ref.watch(reportRepositoryProvider).getStudentReport(
    filter.id,
    startDate: filter.startDate,
    endDate: filter.endDate,
  );
});

// A provider to store the global report date range filter (null by default)
final reportDateRangeProvider = StateProvider<ReportDateRange?>((ref) => null);

class ReportDateRange {
  final DateTime start;
  final DateTime end;
  const ReportDateRange({required this.start, required this.end});
}
