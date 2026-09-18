import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:teacher_dashboard/core/constants/app_constants.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/features/attendance/domain/session_model.dart';
import 'package:teacher_dashboard/features/attendance/presentation/providers/sessions_providers.dart';

class SessionFormSheet extends ConsumerStatefulWidget {
  const SessionFormSheet({
    super.key,
    required this.classId,
    this.session,
    required this.onSaved,
  });

  final int classId;
  final SessionModel? session;
  final VoidCallback onSaved;

  @override
  ConsumerState<SessionFormSheet> createState() => _SessionFormSheetState();
}

class _SessionFormSheetState extends ConsumerState<SessionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _linkController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _saving = false;

  bool get _isEditing => widget.session != null;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.session?.title ?? '');
    _linkController =
        TextEditingController(text: widget.session?.link ?? '');

    if (_isEditing) {
      _selectedDate = DateTime.parse(widget.session!.date);
      final parts = widget.session!.startTime.split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } else {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Form(
          key: _formKey,
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
              const SizedBox(height: 20),

              Text(
                _isEditing ? l10n.editSession : l10n.addSession,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _titleController,
                autofocus: !_isEditing,
                maxLength: AppConstants.maxNameLength,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.sessionTitle,
                  hintText: l10n.sessionTitleHint,
                  prefixIcon: const Icon(Icons.title_rounded),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.sessionTitleRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _linkController,
                keyboardType: TextInputType.url,
                maxLength: AppConstants.maxLinkLength,
                decoration: InputDecoration(
                  labelText: l10n.sessionLink,
                  hintText: l10n.sessionLinkHint,
                  prefixIcon: const Icon(Icons.link_rounded),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickDate(context),
                      icon: const Icon(Icons.calendar_today_rounded, size: 18),
                      label: Text(
                        DateFormat('yyyy-MM-dd').format(_selectedDate),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickTime(context),
                      icon: const Icon(Icons.access_time_rounded, size: 18),
                      label: Text(_selectedTime.format(context)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _saving ? null : () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _submit,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final repo = ref.read(sessionRepositoryProvider);
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final hour = _selectedTime.hour.toString().padLeft(2, '0');
      final minute = _selectedTime.minute.toString().padLeft(2, '0');
      final timeStr = '$hour:$minute';
      final link = _linkController.text.trim();

      if (_isEditing) {
        await repo.update(
          id: widget.session!.id,
          title: _titleController.text.trim(),
          link: link.isEmpty ? null : link,
          date: dateStr,
          startTime: timeStr,
        );
      } else {
        await repo.insert(
          classId: widget.classId,
          title: _titleController.text.trim(),
          link: link.isEmpty ? null : link,
          date: dateStr,
          startTime: timeStr,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
