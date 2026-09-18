import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/core/l10n/app_localizations.dart';
import 'package:teacher_dashboard/core/locale/locale_provider.dart';
import 'package:teacher_dashboard/core/settings/settings_service.dart';
import 'package:teacher_dashboard/core/theme/theme_provider.dart';
import 'package:teacher_dashboard/features/backup/data/backup_service.dart';
import 'package:teacher_dashboard/features/classes/presentation/providers/classes_providers.dart';
import 'package:teacher_dashboard/features/students/presentation/providers/students_providers.dart';
import 'package:teacher_dashboard/features/attendance/presentation/providers/sessions_providers.dart';
import 'package:teacher_dashboard/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:teacher_dashboard/features/notes/presentation/providers/notes_providers.dart';
import 'package:teacher_dashboard/features/timetable/presentation/providers/timetable_providers.dart';
import 'package:teacher_dashboard/features/reports/presentation/providers/reports_providers.dart';

/// Country code validation: + followed by 1–4 digits.
final _countryCodeRegex = RegExp(r'^\+\d{1,4}$');

/// Functional settings screen.
///
/// Currently supports:
/// - Theme mode (system / light / dark)
/// - Language (Arabic / English / system)
/// - Default phone country code
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _countryCodeController;
  late final FocusNode _countryCodeFocus;
  late String _lastSavedCountryCode;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsServiceProvider);
    _lastSavedCountryCode = settings.countryCode;
    _countryCodeController =
        TextEditingController(text: _lastSavedCountryCode);
    _countryCodeFocus = FocusNode()..addListener(_onCountryCodeFocusChange);
  }

  @override
  void dispose() {
    _countryCodeFocus.removeListener(_onCountryCodeFocusChange);
    _countryCodeFocus.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  void _onCountryCodeFocusChange() {
    if (!_countryCodeFocus.hasFocus) {
      _saveCountryCode();
    }
  }

  void _saveCountryCode() {
    final value = _countryCodeController.text.trim();
    if (_countryCodeRegex.hasMatch(value)) {
      _lastSavedCountryCode = value;
      ref.read(settingsServiceProvider).setCountryCode(value);
    } else {
      // Revert to last saved value
      _countryCodeController.text = _lastSavedCountryCode;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.settingsCountryCodeInvalid),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeProvider);
    final settings = ref.read(settingsServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsScreenTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ── Appearance section ──
          _SectionHeader(title: l10n.settingsAppearance),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.palette_outlined,
                    color: colors.primary,
                  ),
                  title: Text(l10n.settingsThemeMode),
                  subtitle: Text(_themeModeLabel(themeMode, l10n)),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colors.textSecondary,
                  ),
                  onTap: () => _showThemePicker(context, themeMode),
                ),
                Divider(height: 1, indent: 56, color: colors.border),
                ListTile(
                  leading: Icon(
                    Icons.language_rounded,
                    color: colors.primary,
                  ),
                  title: Text(l10n.settingsLanguage),
                  subtitle:
                      Text(_localeLabel(settings.localeRaw, l10n)),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colors.textSecondary,
                  ),
                  onTap: () =>
                      _showLocalePicker(context, settings.localeRaw),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── General section ──
          _SectionHeader(title: l10n.settingsGeneral),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone_rounded,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.settingsCountryCode,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.settingsCountryCodeHint,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 90,
                        child: TextField(
                          controller: _countryCodeController,
                          focusNode: _countryCodeFocus,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[+0-9]')),
                            LengthLimitingTextInputFormatter(5),
                          ],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onEditingComplete: _saveCountryCode,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Backup section ──
          _SectionHeader(title: l10n.backupSection),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.upload_file_rounded,
                    color: colors.primary,
                  ),
                  title: Text(l10n.exportDatabase),
                  onTap: () => _exportDatabase(context, ref),
                ),
                Divider(height: 1, indent: 56, color: colors.border),
                ListTile(
                  leading: Icon(
                    Icons.download_rounded,
                    color: colors.absent, // Usually red because it's destructive
                  ),
                  title: Text(l10n.importDatabase, style: TextStyle(color: colors.absent)),
                  onTap: () => _importDatabase(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────

  String _themeModeLabel(ThemeMode mode, AppLocalizations l10n) {
    return switch (mode) {
      ThemeMode.system => l10n.settingsThemeSystem,
      ThemeMode.light => l10n.settingsThemeLight,
      ThemeMode.dark => l10n.settingsThemeDark,
    };
  }

  String _localeLabel(String localeRaw, AppLocalizations l10n) {
    return switch (localeRaw) {
      'ar' => l10n.settingsLanguageArabic,
      'en' => l10n.settingsLanguageEnglish,
      _ => l10n.settingsLanguageSystem,
    };
  }

  void _showThemePicker(BuildContext context, ThemeMode current) {
    final colors = context.colors;
    final l10n = context.l10n;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.settingsThemeMode,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ...ThemeMode.values.map((mode) {
                  final isSelected = mode == current;
                  return ListTile(
                    leading: Icon(
                      switch (mode) {
                        ThemeMode.system => Icons.brightness_auto_rounded,
                        ThemeMode.light => Icons.light_mode_rounded,
                        ThemeMode.dark => Icons.dark_mode_rounded,
                      },
                      color: isSelected ? colors.primary : colors.textSecondary,
                    ),
                    title: Text(_themeModeLabel(mode, l10n)),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded,
                            color: colors.primary)
                        : null,
                    onTap: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(mode);
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLocalePicker(BuildContext context, String current) {
    final colors = context.colors;
    final l10n = context.l10n;

    final options = [
      ('ar', l10n.settingsLanguageArabic, Icons.translate_rounded),
      ('en', l10n.settingsLanguageEnglish, Icons.translate_rounded),
      ('system', l10n.settingsLanguageSystem, Icons.brightness_auto_rounded),
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.settingsLanguage,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ...options.map((opt) {
                  final (code, label, icon) = opt;
                  final isSelected = code == current;
                  return ListTile(
                    leading: Icon(
                      icon,
                      color: isSelected ? colors.primary : colors.textSecondary,
                    ),
                    title: Text(label),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded,
                            color: colors.primary)
                        : null,
                    onTap: () {
                      ref
                          .read(localeProvider.notifier)
                          .setLocale(code);
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _exportDatabase(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(backupServiceProvider).exportDatabase();
    } catch (e, st) {
      debugPrint('Export Error: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _importDatabase(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final colors = context.colors;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.importWarningTitle),
        content: Text(l10n.importWarningBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.importDatabase, style: TextStyle(color: colors.absent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    
    if (confirm != true || !context.mounted) return;
    
    try {
      await ref.read(backupServiceProvider).importDatabase();
      
      // Invalidate all repository providers so the UI refreshes
      ref.invalidate(classRepositoryProvider);
      ref.invalidate(studentRepositoryProvider);
      ref.invalidate(sessionRepositoryProvider);
      ref.invalidate(attendanceRepositoryProvider);
      ref.invalidate(noteRepositoryProvider);
      ref.invalidate(timetableRepositoryProvider);
      ref.invalidate(reportRepositoryProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.restoreSuccess)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}

/// Section header label for settings groups.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
