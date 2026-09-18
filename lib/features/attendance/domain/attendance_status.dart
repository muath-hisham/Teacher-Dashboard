import 'package:flutter/material.dart';
import 'package:teacher_dashboard/core/l10n/app_localizations.dart';
import 'package:teacher_dashboard/core/theme/app_colors.dart';

/// Represents a student's attendance status in a session.
enum AttendanceStatus {
  present('present'),
  late('late'),
  excused('excused'),
  absent('absent');

  const AttendanceStatus(this.dbValue);

  /// The string value stored in the database.
  final String dbValue;

  /// Parses a string from the database into an [AttendanceStatus].
  /// Defaults to [present] if unknown (should not happen with DB constraints).
  static AttendanceStatus fromDb(String value) {
    return AttendanceStatus.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () => AttendanceStatus.present,
    );
  }

  /// Localised label for the UI.
  String label(AppLocalizations l10n) {
    return switch (this) {
      AttendanceStatus.present => l10n.statusPresent,
      AttendanceStatus.late => l10n.statusLate,
      AttendanceStatus.excused => l10n.statusExcused,
      AttendanceStatus.absent => l10n.statusAbsent,
    };
  }

  /// The colour associated with the status.
  Color color(BuildContext context) {
    // using Theme extensions
    final colors = Theme.of(context).extension<AppColors>();
    if (colors == null) return Colors.grey;

    return switch (this) {
      AttendanceStatus.present => colors.present,
      AttendanceStatus.late => colors.late,
      AttendanceStatus.excused => colors.excused,
      AttendanceStatus.absent => colors.absent,
    };
  }
}
