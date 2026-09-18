/// A session (lesson) for a class.
class SessionModel {
  const SessionModel({
    required this.id,
    required this.classId,
    required this.title,
    this.link,
    required this.date,
    required this.startTime,
    required this.createdAt,
  });

  final int id;
  final int classId;
  final String title;
  final String? link;
  final String date; // YYYY-MM-DD
  final String startTime; // HH:MM
  final DateTime createdAt;

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'] as int,
      classId: map['class_id'] as int,
      title: map['title'] as String,
      link: map['link'] as String?,
      date: map['date'] as String,
      startTime: map['start_time'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
