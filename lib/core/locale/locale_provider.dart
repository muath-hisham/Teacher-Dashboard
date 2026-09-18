import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_service.dart';

/// Provides the current [Locale] reactively.
///
/// `null` means "follow the system locale". Otherwise an explicit [Locale]
/// is returned. Reads the persisted value on first access.
final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  return LocaleNotifier(settingsService);
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier(this._settings) : super(_settings.locale);

  final SettingsService _settings;

  Future<void> setLocale(String localeCode) async {
    await _settings.setLocale(localeCode);
    state = switch (localeCode) {
      'ar' => const Locale('ar'),
      'en' => const Locale('en'),
      _ => null, // system
    };
  }
}
