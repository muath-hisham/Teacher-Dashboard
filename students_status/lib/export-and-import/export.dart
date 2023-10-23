import 'dart:convert';

// import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

// Function to export SQLite data to JSON or CSV
Future exportData() async {
  // 1. Get the database path
  String databasePath = await getDatabasesPath();
  String databaseFile = "$databasePath/elmared.db";

  // 2. Open the database
  Database database = await openDatabase(databaseFile);

  // 3. Fetch data from tables
  List<String> tables = [
    "level",
    "lesson",
    "students",
    "attendance",
    "schedule",
    "notes"
  ];
  Map<String, List> allData = {};
  for (String table in tables) {
    try {
      List<Map<String, dynamic>> data =
          await database.rawQuery('SELECT * FROM $table');
      allData.addAll({table: data});
    } catch (e) {
      print("table $table is empty");
    }
  }

  // 4. Convert data to JSON or CSV format
  // For JSON
  String jsonData = jsonEncode(allData);

  // 5. Share data via WhatsApp
  // await Share.share('Your data: $jsonData'); // For JSON
  // or
  await Share.share(jsonData); // For CSV
}
