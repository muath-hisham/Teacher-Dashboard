import 'package:teacher_dashboard/core/database/database_constants.dart';

class NoteModel {
  const NoteModel({
    this.id,
    this.classId,
    required this.body,
    this.createdAt,
  });

  final int? id;
  final int? classId;
  final String body;
  final DateTime? createdAt;

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map[DbColumns.id] as int?,
      classId: map[DbColumns.classId] as int?,
      body: map[DbColumns.body] as String,
      createdAt: map[DbColumns.createdAt] != null 
          ? DateTime.parse(map[DbColumns.createdAt] as String) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DbColumns.id: id,
      DbColumns.classId: classId,
      DbColumns.body: body,
      if (createdAt != null) DbColumns.createdAt: createdAt!.toIso8601String(),
    };
  }
}
