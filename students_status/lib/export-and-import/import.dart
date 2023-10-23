import 'dart:convert';

// import 'package:csv/csv.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:students_status/sqldb.dart';

// Function to import data from JSON or CSV file
Future<void> importData(String data) async {
  // 1. Decode JSON data
  Map<String, dynamic> allData;
  try {
    allData = jsonDecode(data);
  } catch (e) {
    // Handle parsing errors
    print("Error parsing data: $e");
    return;
  }

  // 2. Clear existing dataBase
  SqlDb sqlDb = SqlDb();
  // await sqlDb.deleteDataBase();

  // 3. open the database again
  // Database? db = await sqlDb.db;

  List<dynamic>? levels = allData["level"];
  List<dynamic>? lessons = allData["lesson"];
  List<dynamic>? students = allData["students"];
  List<dynamic>? attendances = allData["attendance"];
  List<dynamic>? schedules = allData["schedule"];
  List<dynamic>? notes = allData["notes"];

  print(levels);

  // 4. Insert the new data into tables
  await sqlDb.insertLevels(levels);
  await sqlDb.insertLessons(lessons);
  await sqlDb.insertStudents(students);
  await sqlDb.insertAttendances(attendances);
  await sqlDb.insertSchedule(schedules);
  await sqlDb.insertNotes(notes);
}
