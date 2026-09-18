import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_dashboard/core/constants/app_constants.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/core/l10n/app_localizations.dart';
import 'package:teacher_dashboard/core/settings/settings_service.dart';
import 'package:teacher_dashboard/core/utils/phone_utils.dart';
import 'package:teacher_dashboard/features/students/domain/student_model.dart';
import 'package:teacher_dashboard/features/students/presentation/providers/students_providers.dart';

/// Bottom sheet form for adding or editing a student.
///
/// If [student] is provided, the form is in edit mode.
/// Phone numbers are normalized using the country code from settings.
class StudentFormSheet extends ConsumerStatefulWidget {
  const StudentFormSheet({
    super.key,
    required this.classId,
    this.student,
    required this.onSaved,
  });

  final int classId;
  final StudentModel? student;
  final VoidCallback onSaved;

  @override
  ConsumerState<StudentFormSheet> createState() => _StudentFormSheetState();
}

class _StudentFormSheetState extends ConsumerState<StudentFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _guardianPhoneController;
  bool _saving = false;

  bool get _isEditing => widget.student != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.student?.name ?? '');
    _phoneController =
        TextEditingController(text: widget.student?.phone ?? '');
    _guardianPhoneController =
        TextEditingController(text: widget.student?.guardianPhone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _guardianPhoneController.dispose();
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
              // ── Handle bar ──
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // ── Title ──
              Text(
                _isEditing ? l10n.editStudent : l10n.addStudent,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              // ── Name ──
              TextFormField(
                controller: _nameController,
                autofocus: !_isEditing,
                maxLength: AppConstants.maxNameLength,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.studentName,
                  hintText: l10n.studentNameHint,
                  prefixIcon: const Icon(Icons.person_rounded),
                ),
                validator: (v) => _validateName(v, l10n),
              ),
              const SizedBox(height: 16),

              // ── Phone ──
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                maxLength: AppConstants.maxPhoneLength,
                decoration: InputDecoration(
                  labelText: l10n.studentPhone,
                  hintText: l10n.studentPhoneHint,
                  prefixIcon: const Icon(Icons.phone_rounded),
                ),
                validator: (v) => _validatePhone(v, l10n),
              ),
              const SizedBox(height: 16),

              // ── Guardian phone ──
              TextFormField(
                controller: _guardianPhoneController,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                maxLength: AppConstants.maxPhoneLength,
                decoration: InputDecoration(
                  labelText: l10n.studentGuardianPhone,
                  hintText: l10n.studentGuardianPhoneHint,
                  prefixIcon: const Icon(Icons.supervisor_account_rounded),
                ),
                validator: (v) => _validatePhone(v, l10n),
              ),
              const SizedBox(height: 28),

              // ── Actions ──
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
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
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

  String? _validateName(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return l10n.studentNameRequired;
    if (RegExp(r'[\x00-\x1F\x7F]').hasMatch(trimmed)) {
      return l10n.invalidPhoneNumber; // A bit of a hack since we don't have invalid name chars ARB key, but better to use existing
    }
    return null;
  }

  String? _validatePhone(String? value, AppLocalizations l10n) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return null; // phone is optional
    final countryCode =
        ref.read(settingsServiceProvider).countryCode;
    final normalized = PhoneUtils.normalizePhone(raw, countryCode);
    if (normalized == null || !PhoneUtils.isValidPhone(normalized)) {
      return l10n.invalidPhoneNumber;
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final countryCode = ref.read(settingsServiceProvider).countryCode;
    final name = _nameController.text.trim();
    final rawPhone = _phoneController.text.trim();
    final rawGuardian = _guardianPhoneController.text.trim();

    final phone = rawPhone.isEmpty
        ? null
        : PhoneUtils.normalizePhone(rawPhone, countryCode);
    final guardianPhone = rawGuardian.isEmpty
        ? null
        : PhoneUtils.normalizePhone(rawGuardian, countryCode);

    final repo = ref.read(studentRepositoryProvider);

    try {
      if (_isEditing) {
        await repo.update(
          id: widget.student!.id,
          name: name,
          phone: phone,
          guardianPhone: guardianPhone,
        );
      } else {
        await repo.insert(
          classId: widget.classId,
          name: name,
          phone: phone,
          guardianPhone: guardianPhone,
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
