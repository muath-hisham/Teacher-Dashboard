import 'package:go_router/go_router.dart';

import 'package:teacher_dashboard/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:teacher_dashboard/features/attendance/presentation/screens/sessions_screen.dart';
import 'package:teacher_dashboard/features/classes/presentation/screens/class_details_screen.dart';
import 'package:teacher_dashboard/features/classes/presentation/screens/classes_screen.dart';
import 'package:teacher_dashboard/features/reports/presentation/screens/reports_screen.dart';
import 'package:teacher_dashboard/features/reports/presentation/screens/student_report_screen.dart';
import 'package:teacher_dashboard/features/settings/presentation/screens/settings_screen.dart';
import 'package:teacher_dashboard/features/splash/presentation/screens/splash_screen.dart';
import 'package:teacher_dashboard/features/timetable/presentation/screens/timetable_notes_shell_screen.dart';
import 'package:teacher_dashboard/shared/widgets/app_shell.dart';

/// Route path constants.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const classes = '/classes';
  static const classDetails = '/classes/:classId';
  static const attendance = '/classes/:classId/attendance/:sessionId';
  static const timetable = '/timetable';
  static const reports = '/reports';
  static const settings = '/settings';
}

/// The top-level [GoRouter] configuration.
///
/// Uses [StatefulShellRoute] to keep bottom-nav tab state alive across
/// navigation.
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        // ── Tab 0: Classes ──
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.classes,
              builder: (context, state) => const ClassesScreen(),
              routes: [
                GoRoute(
                  path: ':classId',
                  builder: (context, state) {
                    final classId =
                        int.parse(state.pathParameters['classId']!);
                    return ClassDetailsScreen(classId: classId);
                  },
                  routes: [
                    GoRoute(
                      path: 'sessions',
                      builder: (context, state) {
                        final classId =
                            int.parse(state.pathParameters['classId']!);
                        return SessionsScreen(classId: classId);
                      },
                      routes: [
                        GoRoute(
                          path: ':sessionId/attendance',
                          builder: (context, state) {
                            final classId =
                                int.parse(state.pathParameters['classId']!);
                            final sessionId =
                                int.parse(state.pathParameters['sessionId']!);
                            return AttendanceScreen(
                              classId: classId,
                              sessionId: sessionId,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // ── Tab 1: Timetable ──
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.timetable,
              builder: (context, state) => const TimetableNotesShellScreen(),
            ),
          ],
        ),

        // ── Tab 2: Reports ──
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.reports,
              builder: (context, state) => const ReportsScreen(),
              routes: [
                GoRoute(
                  path: 'student/:studentId',
                  builder: (context, state) {
                    final studentId = int.parse(state.pathParameters['studentId']!);
                    return StudentReportScreen(studentId: studentId);
                  },
                ),
              ],
            ),
          ],
        ),

        // ── Tab 3: Settings ──
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
