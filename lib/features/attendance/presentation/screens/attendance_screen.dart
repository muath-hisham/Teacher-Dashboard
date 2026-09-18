import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_model.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_status.dart';
import 'package:teacher_dashboard/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:teacher_dashboard/features/attendance/presentation/providers/sessions_providers.dart';
import 'package:teacher_dashboard/features/attendance/presentation/screens/attendance_whatsapp_sheet.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({
    super.key,
    required this.classId,
    required this.sessionId,
  });

  final int classId;
  final int sessionId;

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Schedule init after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(attendanceFormProvider(widget.sessionId).notifier).init(widget.classId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final sessionAsync = ref.watch(sessionsListProvider(widget.classId));
    final session = sessionAsync.whenOrNull(
      data: (list) => list.where((s) => s.id == widget.sessionId).firstOrNull,
    );

    final formStateAsync = ref.watch(attendanceFormProvider(widget.sessionId));

    return Scaffold(
      appBar: AppBar(
        title: Text(session?.title ?? l10n.attendance),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: colors.textPrimary),
            onSelected: (value) {
              final notifier = ref.read(attendanceFormProvider(widget.sessionId).notifier);
              if (value == 'mark_present') {
                notifier.markAll(AttendanceStatus.present);
              } else if (value == 'mark_absent') {
                notifier.markAll(AttendanceStatus.absent);
              } else if (value == 'whatsapp' && session != null) {
                _showWhatsAppSheet(context, formStateAsync.valueOrNull ?? [], session.link, session.title);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'mark_present',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, color: colors.present),
                    const SizedBox(width: 12),
                    Text(l10n.markAllPresent),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'mark_absent',
                child: Row(
                  children: [
                    Icon(Icons.cancel_outlined, color: colors.absent),
                    const SizedBox(width: 12),
                    Text(l10n.markAllAbsent),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'whatsapp',
                enabled: session?.link != null,
                child: Row(
                  children: [
                    Icon(Icons.message_rounded, color: colors.primary),
                    const SizedBox(width: 12),
                    Text(l10n.sendWhatsApp),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: formStateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (rows) {
          if (rows.isEmpty) {
            return Center(
              child: Text(l10n.noStudentsSubtitle),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: rows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _AttendanceRowCard(
                row: rows[index],
                sessionId: widget.sessionId,
              );
            },
          );
        },
      ),
      floatingActionButton: formStateAsync.hasValue && formStateAsync.value!.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _saving ? null : () => _save(context),
              icon: _saving 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save_rounded),
              label: Text(l10n.save),
            )
          : null,
    );
  }

  void _showWhatsAppSheet(BuildContext context, List<AttendanceRowState> rows, String? link, String title) {
    if (link == null) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return AttendanceWhatsAppSheet(
          rows: rows,
          sessionLink: link,
          sessionTitle: title,
        );
      },
    );
  }

  Future<void> _save(BuildContext context) async {
    setState(() => _saving = true);
    try {
      final notifier = ref.read(attendanceFormProvider(widget.sessionId).notifier);
      await notifier.save();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.attendanceSaved)),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _AttendanceRowCard extends ConsumerStatefulWidget {
  const _AttendanceRowCard({
    required this.row,
    required this.sessionId,
  });

  final AttendanceRowState row;
  final int sessionId;

  @override
  ConsumerState<_AttendanceRowCard> createState() => _AttendanceRowCardState();
}

class _AttendanceRowCardState extends ConsumerState<_AttendanceRowCard> {
  bool _isEditingNote = false;
  late TextEditingController _noteController;
  late FocusNode _noteFocusNode;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.row.note ?? '');
    _noteFocusNode = FocusNode();
    _noteFocusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (!_noteFocusNode.hasFocus) {
      _commitNote();
    }
  }

  void _commitNote() {
    final note = _noteController.text.trim();
    ref.read(attendanceFormProvider(widget.sessionId).notifier).updateNote(
          widget.row.studentId,
          note.isEmpty ? null : note,
        );
  }

  @override
  void didUpdateWidget(covariant _AttendanceRowCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.row.note != widget.row.note) {
      if (!_noteFocusNode.hasFocus) {
        _noteController.text = widget.row.note ?? '';
      }
    }
  }

  @override
  void dispose() {
    _noteFocusNode.removeListener(_onFocusChanged);
    _noteFocusNode.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final row = widget.row;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.primary,
                  child: Text(row.studentName.isNotEmpty ? row.studentName[0] : '?'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    row.studentName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isEditingNote || row.note != null
                        ? Icons.edit_note_rounded
                        : Icons.note_add_outlined,
                    color: row.note != null ? colors.primary : colors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEditingNote = !_isEditingNote;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Status selection
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: AttendanceStatus.values.map((status) {
                  final isSelected = row.status == status;
                  final statusColor = status.color(context);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status.label(context.l10n)),
                      selected: isSelected,
                      selectedColor: statusColor.withAlpha(40),
                      labelStyle: TextStyle(
                        color: isSelected ? statusColor : colors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected ? statusColor : colors.border,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          ref
                              .read(attendanceFormProvider(widget.sessionId).notifier)
                              .updateStatus(row.studentId, status);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            
            // Note field
            if (_isEditingNote || row.note != null) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                focusNode: _noteFocusNode,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  _noteFocusNode.unfocus();
                },
                decoration: InputDecoration(
                  hintText: context.l10n.attendanceNote,
                  filled: true,
                  fillColor: colors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
