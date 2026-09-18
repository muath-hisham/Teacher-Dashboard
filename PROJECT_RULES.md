# PROJECT_RULES.md

## Architecture
- Clean Architecture: core/ + features/<feature>/{data,domain,presentation}
- Riverpod for state, go_router for navigation, sqflite for storage
- One responsibility per file. No god-files, no widget over ~150 lines.
- Keep it simple. No extra abstraction layers, no over-engineering.

## Database
- ALL queries use parameterized args (whereArgs / positional ?). NEVER string interpolation. No exceptions.
- All writes that touch more than one table run in a transaction.
- Foreign keys ON, ON DELETE CASCADE.

## Strings
- No string literals in widgets. Everything in app_ar.arb / app_en.arb, accessed via context.l10n.<key>
- Semantic key names (e.g. attendanceMarkPresent, not text1)
- Arabic is the default locale, full RTL support.

## Colors & theme
- ThemeExtension<AppColors>, light + dark instances registered in ThemeData.extensions, read via context.colors
- NEVER hardcode a Color in a widget. NEVER use Colors.blue / Colors.red etc.
- Palette (education domain: calm teal + warm amber — trustworthy, not corporate, not generic blue):
  LIGHT: primary #0F766E | primaryContainer #CCFBF1 | accent #F59E0B |
         background #F8FAF9 | surface #FFFFFF | surfaceVariant #F1F5F4 |
         textPrimary #0F172A | textSecondary #64748B | border #E2E8F0
  DARK:  primary #2DD4BF | primaryContainer #134E4A | accent #FBBF24 |
         background #0B1220 | surface #131C2B | surfaceVariant #1B2537 |
         textPrimary #E2E8F0 | textSecondary #94A3B8 | border #243044
  STATUS (both themes): present #16A34A | absent #DC2626 | late #F59E0B | excused #0284C7
- Never use color alone to carry meaning — always pair with an icon or label.

## Layout
- No hardcoded pixel heights for containers or lists. No screen-size ratio helpers.
- Use Expanded / Flexible / LayoutBuilder. Everything must survive a small phone and a tablet.

## Design
- Modern, clean, calm, education-focused. Use the ux_ui_pro_max skill on every screen.
- Design decisions (spacing, layout, motion, component choice) are yours — make it good.

## Security
- Input validation: never trust student/class names, notes, or imported files. Length limits, trim, reject control chars.
- SQL injection: parameterized queries only (see Database).
- Backup import: validate the JSON schema before writing anything. Reject unknown keys, wrong types, malformed rows. Import inside a transaction so a bad file can't leave a half-written DB.
- Data at rest: SQLite lives in app-private storage. Never write backups to shared/public storage without an explicit user action (share sheet / file picker).
- Logging: no print/debugPrint of student names, phone numbers, or note contents — ever, not even in debug.
- Deep links: validate and normalize phone numbers before building a wa.me URL. Country code is a user setting, never hardcoded.
- Permissions: request storage/share permissions only at the moment they're used, and handle denial gracefully.

## At the end of each phase
Run `flutter analyze` and fix everything. Then give: (1) a short summary of what was built, (2) a manual test checklist for me.
Write only the tests that matter for the phase's core logic. No large test suites.
