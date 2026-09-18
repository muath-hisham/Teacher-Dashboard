import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/database/database_helper.dart';
import 'core/settings/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Async initialisation ──────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService(prefs);

  // Initialise the database (creates tables on first launch).
  await DatabaseHelper.instance.database;

  // ── Run ────────────────────────────────────────────────────────────
  runApp(
    ProviderScope(
      overrides: [
        settingsServiceProvider.overrideWithValue(settingsService),
      ],
      child: const TeacherDashboardApp(),
    ),
  );
}
