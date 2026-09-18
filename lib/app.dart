import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/l10n/app_localizations.dart';
import 'core/locale/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

/// Root widget of the Teacher Dashboard app.
///
/// Drives theme and locale from Riverpod providers backed by
/// SharedPreferences. **This file should not be modified after Phase 0.**
class TeacherDashboardApp extends ConsumerWidget {
  const TeacherDashboardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'المارد',
      debugShowCheckedModeBanner: false,

      // ── Localisation ──
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,

      // ── Theme ──
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,

      // ── Routing ──
      routerConfig: appRouter,
    );
  }
}
