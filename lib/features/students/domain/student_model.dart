/// A student entity belonging to a class.
class StudentModel {
  const StudentModel({
    required this.id,
    required this.classId,
    required this.name,
    this.phone,
    this.guardianPhone,
    required this.createdAt,
  });

  final int id;
  final int classId;
  final String name;
  final String? phone;
  final String? guardianPhone;
  final DateTime createdAt;

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] as int,
      classId: map['class_id'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      guardianPhone: map['guardian_phone'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
