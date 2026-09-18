import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_service.dart';

/// Provides the current [ThemeMode] reactively.
///
/// Reads the persisted value on first access and updates whenever
/// the user changes the theme in Settings.
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  return ThemeModeNotifier(settingsService);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._settings) : super(_settings.themeMode);

  final SettingsService _settings;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _settings.setThemeMode(mode);
  }
}
