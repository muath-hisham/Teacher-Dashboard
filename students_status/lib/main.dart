import 'package:flutter/material.dart';
import 'package:students_status/screens/add_course.dart';
import 'package:students_status/screens/attendance.dart';
import 'package:students_status/screens/home.dart';
import 'package:students_status/screens/profile.dart';
import 'package:students_status/screens/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'home' :(context) => HomePage(),
        'addCourse' :(context) => AddCourse(),
        'settings' :(context) => Settings(),
        'profile' :(context) => ProfilePage(),
        'attendance':(context) => Attendance(),
      },
      home: HomePage(),
    );
  }
}

