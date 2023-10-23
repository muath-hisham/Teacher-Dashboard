import 'package:flutter/material.dart';
import 'package:students_status/screens/add_course.dart';
import 'package:students_status/screens/shared/BottomBar.dart';
import 'package:students_status/screens/shared/dimensions.dart';
import 'package:students_status/screens/shared/lesson_card.dart';
import 'package:students_status/screens/shared/student_card.dart';
import 'package:students_status/sqldb.dart';

class LevelDetails extends StatefulWidget {
  final Map level;
  const LevelDetails({super.key, required this.level});

  @override
  State<LevelDetails> createState() => _LevelDetailsState();
}

class _LevelDetailsState extends State<LevelDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getAllStudents();
  }

  Future getAllLessons() async {
    List<Map> lessons = await sqlDb.readData(
        "SELECT * FROM lesson WHERE level_id = ${widget.level['level_id']}");
    if (lessons.isEmpty) {
      return "empty";
    }
    return lessons;
  }

  Future getAllStudents() async {
    List<Map> students = await sqlDb.readData(
        "SELECT * FROM students WHERE level_id = ${widget.level['level_id']}");
    if (students.isEmpty) {
      return "empty";
    }
    return students;
  }

  void _handleStudentDeleted() {
    // Trigger a rebuild of the widget tree by calling setState
    setState(() {
      getAllStudents();
    });
  }

  void _handleLessonDeleted() {
    // Trigger a rebuild of the widget tree by calling setState
    setState(() {
      getAllLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: Dimensions(context).height(70)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(bottom: Dimensions(context).height(20)),
                  child: Text(
                    widget.level['name'],
                    style: TextStyle(
                      fontSize: Dimensions(context).fontSize(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Dimensions(context).horizontal(25)),
                  // color: Colors.redAccent,
                  child: TabBar(
                      isScrollable: true,
                      //labelPadding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(30)),
                      controller: _tabController,
                      //indicatorColor: Colors.transparent,
                      labelColor: Color(0xFF1C1C3E),
                      //isScrollable: true,
                      //labelPadding: EdgeInsets.only(right: 45.0),
                      unselectedLabelColor: Color(0xFFCDCDCD),
                      tabs: [
                        Tab(
                          child: Text(
                            "الدروس",
                            style: TextStyle(
                              //  fontWeight: FontWeight.bold,
                              fontSize: Dimensions(context).fontSize(15),
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "الطلاب",
                            style: TextStyle(
                              // color: Colors.white,
                              fontSize: Dimensions(context).fontSize(15),
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  height: Dimensions(context).height(565),
                  width: double.infinity,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // List of lessons
                      FutureBuilder(
                        future: getAllLessons(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != "empty") {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      Dimensions(context).horizontal(30),
                                  vertical: Dimensions(context).vertical(30),
                                ),
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return CardLesson(
                                      lesson: snapshot.data[index],
                                      onDelete: _handleLessonDeleted,
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Center(child: Text("لا يوجد اي دروس"));
                            }
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                      // List of students
                      FutureBuilder(
                        future: getAllStudents(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != "empty") {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      Dimensions(context).horizontal(30),
                                  vertical: Dimensions(context).vertical(30),
                                ),
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return CardStudent(
                                      student: snapshot.data[index],
                                      onDelete: _handleStudentDeleted,
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Center(child: Text("لا يوجد اي طالب"));
                            }
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
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
      bottomNavigationBar: BottomBar(active: ""),
    );
  }
}
