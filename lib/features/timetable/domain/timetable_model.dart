import 'package:teacher_dashboard/core/database/database_constants.dart';

class TimetableModel {
  const TimetableModel({
    this.id,
    required this.dayIndex,
    required this.periodIndex,
    required this.classId,
  });

  final int? id;
  final int dayIndex;
  final int periodIndex;
  final int classId;

  factory TimetableModel.fromMap(Map<String, dynamic> map) {
    return TimetableModel(
      id: map[DbColumns.id] as int?,
      dayIndex: map[DbColumns.dayIndex] as int,
      periodIndex: map[DbColumns.periodIndex] as int,
      classId: map[DbColumns.classId] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DbColumns.id: id,
      DbColumns.dayIndex: dayIndex,
      DbColumns.periodIndex: periodIndex,
      DbColumns.classId: classId,
    };
  }
}
