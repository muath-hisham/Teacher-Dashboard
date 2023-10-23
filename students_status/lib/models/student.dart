class Student {
  int id = 0;
  String name = "";
  String phone = "";
  int levelId = 0;

  Student(Map data) {
    id = data['student_id'];
    name = data['name'];
    phone = data['phone'];
    levelId = data['level_id'];
  }

  Map toMap() {
    return {
      'student_id': id,
      'name': name,
      'phone': phone,
      'level_id': levelId
    };
  }
}
