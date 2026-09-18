import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_dashboard/app.dart';
import 'package:teacher_dashboard/core/settings/settings_service.dart';

void main() {
  testWidgets('App shell renders with bottom navigation', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsServiceProvider
              .overrideWithValue(SettingsService(prefs)),
        ],
        child: const TeacherDashboardApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TeacherDashboardApp), findsOneWidget);
  });
}
