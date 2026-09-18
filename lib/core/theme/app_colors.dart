import 'package:flutter/material.dart';

/// Education-domain color palette as a [ThemeExtension].
///
/// Light: calm teal + warm amber. Dark: elevated teal + brighter amber.
/// Status colors are shared across both themes.
///
/// Access via `Theme.of(context).extension<AppColors>()!` or the
/// `context.colors` shortcut from `context_extensions.dart`.
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryContainer,
    required this.accent,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.present,
    required this.absent,
    required this.late,
    required this.excused,
  });

  final Color primary;
  final Color primaryContainer;
  final Color accent;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;

  // Status colors
  final Color present;
  final Color absent;
  final Color late;
  final Color excused;

  // ── Light instance ──────────────────────────────────────────────────
  static const light = AppColors(
    primary: Color(0xFF0F766E),
    primaryContainer: Color(0xFFCCFBF1),
    accent: Color(0xFFF59E0B),
    background: Color(0xFFF8FAF9),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF1F5F4),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    border: Color(0xFFE2E8F0),
    present: Color(0xFF16A34A),
    absent: Color(0xFFDC2626),
    late: Color(0xFFF59E0B),
    excused: Color(0xFF0284C7),
  );

  // ── Dark instance ───────────────────────────────────────────────────
  static const dark = AppColors(
    primary: Color(0xFF2DD4BF),
    primaryContainer: Color(0xFF134E4A),
    accent: Color(0xFFFBBF24),
    background: Color(0xFF0B1220),
    surface: Color(0xFF131C2B),
    surfaceVariant: Color(0xFF1B2537),
    textPrimary: Color(0xFFE2E8F0),
    textSecondary: Color(0xFF94A3B8),
    border: Color(0xFF243044),
    present: Color(0xFF16A34A),
    absent: Color(0xFFDC2626),
    late: Color(0xFFF59E0B),
    excused: Color(0xFF0284C7),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryContainer,
    Color? accent,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? present,
    Color? absent,
    Color? late,
    Color? excused,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      present: present ?? this.present,
      absent: absent ?? this.absent,
      late: late ?? this.late,
      excused: excused ?? this.excused,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      present: Color.lerp(present, other.present, t)!,
      absent: Color.lerp(absent, other.absent, t)!,
      late: Color.lerp(late, other.late, t)!,
      excused: Color.lerp(excused, other.excused, t)!,
    );
  }
}
