import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:students_status/screens/shared/BottomBar.dart';
import 'package:students_status/screens/shared/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sqldb.dart';
import 'add_course.dart';

List<bool> studentAttendance = [];
List<bool> studentAttendanceUpdated = [];

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  // final _formKey = GlobalKey<FormState>();

  SqlDb sqlDb = SqlDb();

  String? levelId;
  List<Map> levels = [];

  List<Map> lessonsMasters = [];

  String? lessonId;
  List<Map> lessons = [];

  List<Map> students = [];

  List<Map> attendance = [];

  List<String> numbersToSendLink = [];

  bool isChanged = false;

  Future getAllLevels() async {
    levels = await sqlDb.readData("SELECT * FROM `level`");
    print(levels);
    return levels;
  }

  Future getAllLessons() async {
    lessonsMasters = await sqlDb.readData("SELECT * FROM `lesson`");
    print(lessonsMasters);
    return lessonsMasters;
  }

  Future getAllStudents(String? levelId) async {
    List<Map> l = await sqlDb
        .readData("SELECT * FROM `students` WHERE level_id = $levelId");
    setState(() {
      students = l;
    });
    print(students);
  }

  Future<void> getAllAttendanceAndUpdate(String? lessonId) async {
    print("===========insid getAllAttendance=================");
    List<Map>? l = await sqlDb.readData(
        "SELECT * FROM `attendance` WHERE lesson_id = ${int.parse(lessonId!)}");
    setState(() {
      attendance = l;
      studentAttendance.clear(); // Clear the previous data before updating.
      studentAttendanceUpdated.clear();
      for (int i = 0; i < students.length; i++) {
        isChanged = true;
        studentAttendance.add(false);
        studentAttendanceUpdated.add(false);
        for (int j = 0; j < attendance.length; j++) {
          if (students[i]['student_id'] == attendance[j]['student_id']) {
            studentAttendance[i] = true;
            break; // Once found, no need to check further for this student.
          }
        }
      }
      isChanged = false;
    });
    print("the student att is $studentAttendance");
  }

  Future saveAttendance() async {
    for (int i = 0; i < studentAttendanceUpdated.length; i++) {
      if (studentAttendanceUpdated[i] == true) {
        if (studentAttendance[i] == true) {
          sqlDb.insertData('''
            INSERT INTO attendance (student_id, lesson_id) VALUES (${students[i]['student_id']}, $lessonId)
          ''');
          numbersToSendLink.add(students[i]['phone']);
        } else {
          sqlDb.deleteData('''
            DELETE FROM attendance WHERE student_id = ${students[i]['student_id']} AND lesson_id = $lessonId
          ''');
        }
      }
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      // title: lang['success'],
      desc: "تمت العملية بنجاح",
    )..show();
  }

  @override
  void initState() {
    super.initState();
    getAllLessons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.only(top: Dimensions(context).height(80)),
          // height: Dimensions(context).height(700),
          child: Column(children: [
            Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions(context).horizontal(30),
                  vertical: Dimensions(context).vertical(20),
                ),
                child: FutureBuilder(
                  future: getAllLevels(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          FormHelper.dropDownWidget(
                            context,
                            "المرحلة",
                            levelId,
                            levels,
                            (onChangedVal) {
                              setState(() {
                                levelId = onChangedVal;
                                print("selected country is $levelId");
                                lessons = lessonsMasters
                                    .where((element) =>
                                        element['level_id'].toString() ==
                                        onChangedVal.toString())
                                    .toList();
                                lessonId = null;
                                students = [];
                              });
                            },
                            (onValidateVal) {
                              if (onValidateVal == null) {
                                return "يجب اختيار مرحلة";
                              }
                              return null;
                            },
                            borderColor: Colors.grey,
                            borderFocusColor: Theme.of(context).primaryColor,
                            borderRadius: 6,
                            paddingLeft: 0,
                            paddingRight: 2,
                            optionValue: "level_id",
                          ),
                          SizedBox(height: Dimensions(context).height(20)),
                          FormHelper.dropDownWidget(
                            context,
                            "الدرس",
                            lessonId,
                            lessons,
                            (onChangedVal) async {
                              setState(() {
                                lessonId = onChangedVal;
                                print("selected level is $lessonId");
                                attendance = [];
                                students = [];
                              });
                              await getAllStudents(levelId);
                              await getAllAttendanceAndUpdate(lessonId);
                            },
                            (onValidateVal) {
                              if (onValidateVal == null) {
                                return "يجب أختيار درس";
                              }
                              return null;
                            },
                            borderColor: Colors.grey,
                            borderFocusColor: Theme.of(context).primaryColor,
                            borderRadius: 6,
                            paddingLeft: 0,
                            paddingRight: 2,
                            optionValue: "lesson_id",
                          ),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )),
            // SizedBox(height: Dimensions(context).height(15)),
            isChanged
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions(context).horizontal(20)),
                      child: ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                                title: Text(students[index]['name']),
                                trailing: CheckboxExample(index: index)),
                          );
                        },
                      ),
                    ),
                  ),
            students.isEmpty
                ? SizedBox()
                : Container(
                    margin:
                        EdgeInsets.only(bottom: Dimensions(context).height(50)),
                    child: MaterialButton(
                      color: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text("حفظ",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        saveAttendance();
                        // _sendWhatsAppMessage();
                      },
                    ),
                  ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        onPressed: () {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AddCourse(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 1.0);
              var end = Offset.zero;
              var tween = Tween(begin: begin, end: end);
              var curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.ease,
              );

              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              );
            },
          ));
        },
        backgroundColor: Color(0xFFF17532),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBar(active: "attendance"),
    );
  }
}

class CheckboxExample extends StatefulWidget {
  final int index;
  const CheckboxExample({super.key, required this.index});

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isChecked = false;

  // @override
  // void initState() {
  //   super.initState();
  //   isChecked = studentAttendance[widget.index];
  // }

  void delayedFunction() async {
    await Future.delayed(
        Duration(milliseconds: 500)); // Change the duration as needed.
    // This code will be executed after the delay.
    print('Delayed function executed.');
    // You can update UI, call other functions, etc., here after the delay.
    setState(() {
      if (widget.index < studentAttendance.length) {
        // Add this check to ensure the index is valid.
        isChecked = studentAttendance[widget.index];
      }
    });
  }

  @override
  void initState() {
    delayedFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
          studentAttendance[widget.index] = isChecked;
          studentAttendanceUpdated[widget.index] = true;
          print(studentAttendance);
        });
      },
    );
  }
}
