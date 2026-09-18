import 'package:flutter/material.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/features/notes/presentation/screens/notes_screen.dart';
import 'package:teacher_dashboard/features/timetable/presentation/screens/timetable_grid_screen.dart';

class TimetableNotesShellScreen extends StatelessWidget {
  const TimetableNotesShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.timetableAndNotesTitle),
          bottom: TabBar(
            labelColor: colors.primary,
            unselectedLabelColor: colors.textSecondary,
            indicatorColor: colors.primary,
            tabs: [
              Tab(text: l10n.timetable),
              Tab(text: l10n.notes),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TimetableGridScreen(),
            NotesScreen(),
          ],
        ),
      ),
    );
  }
}
