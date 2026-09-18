import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys used in SharedPreferences.
abstract final class _Keys {
  static const themeMode = 'settings_theme_mode';
  static const countryCode = 'settings_country_code';
  static const locale = 'settings_locale';
}

/// Singleton provider — initialised asynchronously before app start.
final settingsServiceProvider = Provider<SettingsService>((ref) {
  // The instance is overridden in main.dart after async init.
  throw UnimplementedError('settingsServiceProvider must be overridden');
});

/// Thin wrapper around [SharedPreferences] for app-level settings.
///
/// Currently stores:
/// - **Theme mode** (system / light / dark)
/// - **Default phone country code** (e.g. "+20")
/// - **Locale** (ar / en / system, default ar)
class SettingsService {
  SettingsService(this._prefs);

  final SharedPreferences _prefs;

  // ── Theme mode ────────────────────────────────────────────────────

  ThemeMode get themeMode {
    final raw = _prefs.getString(_Keys.themeMode);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(_Keys.themeMode, value);
  }

  // ── Country code ──────────────────────────────────────────────────

  String get countryCode => _prefs.getString(_Keys.countryCode) ?? '+20';

  Future<void> setCountryCode(String code) async {
    await _prefs.setString(_Keys.countryCode, code.trim());
  }

  // ── Locale ────────────────────────────────────────────────────────

  /// Returns `null` for system locale, or an explicit locale code.
  Locale? get locale {
    final raw = _prefs.getString(_Keys.locale);
    return switch (raw) {
      'ar' => const Locale('ar'),
      'en' => const Locale('en'),
      _ => null, // system
    };
  }

  /// Raw string value for display: 'ar', 'en', or 'system'.
  String get localeRaw => _prefs.getString(_Keys.locale) ?? 'ar';

  Future<void> setLocale(String localeCode) async {
    await _prefs.setString(_Keys.locale, localeCode);
  }
}
