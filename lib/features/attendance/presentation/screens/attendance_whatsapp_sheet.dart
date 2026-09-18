import 'package:flutter/material.dart';
import 'package:teacher_dashboard/core/extensions/context_extensions.dart';
import 'package:teacher_dashboard/core/utils/whatsapp_utils.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_model.dart';
import 'package:teacher_dashboard/features/attendance/domain/attendance_status.dart';

class AttendanceWhatsAppSheet extends StatelessWidget {
  const AttendanceWhatsAppSheet({
    super.key,
    required this.rows,
    required this.sessionLink,
    required this.sessionTitle,
  });

  final List<AttendanceRowState> rows;
  final String sessionLink;
  final String sessionTitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    
    // Filter out rows that have no phone numbers to send to
    final validRows = rows.where((r) => r.studentPhone != null || r.guardianPhone != null).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l10n.sendWhatsApp,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          if (validRows.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No phone numbers available for students in this class.',
                style: TextStyle(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: validRows.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final row = validRows[index];
                  final isAbsent = row.status == AttendanceStatus.absent;
                  
                  return Card(
                    elevation: 0,
                    color: isAbsent ? colors.absent.withAlpha(20) : colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isAbsent ? colors.absent.withAlpha(100) : colors.border),
                    ),
                    child: ListTile(
                      title: Text(row.studentName),
                      subtitle: Text(row.studentPhone ?? row.guardianPhone ?? ''),
                      trailing: const Icon(Icons.message_rounded, color: Colors.green),
                      onTap: () async {
                        // Replace placeholders in the ARB template
                        final message = l10n.whatsappTemplate(sessionTitle, sessionLink);
                            
                        final phone = row.studentPhone ?? row.guardianPhone!;
                        final success = await WhatsAppUtils.sendLink(phone, message);
                        
                        if (!context.mounted) return;
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.whatsappLaunchFailed)),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
