/// A class (grade / section) entity.
class ClassModel {
  const ClassModel({
    required this.id,
    required this.name,
    required this.studentCount,
    required this.createdAt,
  });

  final int id;
  final String name;
  final int studentCount;
  final DateTime createdAt;

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] as int,
      name: map['name'] as String,
      studentCount: map['student_count'] as int? ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
