import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// Convenient shortcuts for [BuildContext].
extension ContextExtensions on BuildContext {
  /// Access the generated localisation strings.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Access [AppColors] from the current theme.
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
