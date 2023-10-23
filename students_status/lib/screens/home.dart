import 'package:flutter/material.dart';
import 'package:students_status/screens/add_course.dart';
import 'package:students_status/screens/shared/BottomBar.dart';
import 'package:students_status/screens/shared/dimensions.dart';
import 'package:students_status/screens/shared/level_card.dart';
import 'package:students_status/sqldb.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SqlDb sqlDb = SqlDb();

  List<Map> levels = [];
  List<int> noStudentLevels = [];
  List<int> noLessonLevels = [];

  Future fillData() async {
    levels = await sqlDb.readData("SELECT * FROM level");
    for (var level in levels) {
      List l = await sqlDb.readData(
          "SELECT * FROM lesson WHERE level_id = ${level['level_id']}");

      noLessonLevels.add(l.length);

      List l2 = await sqlDb.readData(
          "SELECT * FROM students WHERE level_id = ${level['level_id']}");

      noStudentLevels.add(l2.length);
    }

    print("=========================================");
    print(levels);
    print(noLessonLevels);
    print(noStudentLevels);
    print("=========================================");

    if (levels.length == 0) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions(context).horizontal(20),
          vertical: Dimensions(context).vertical(50),
        ),
        child: FutureBuilder(
          future: fillData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                print("------------------------ ${levels.length}");
                return ListView.builder(
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    return CardLevel(
                      level: levels[index],
                      noLessons: noLessonLevels[index],
                      noStudents: noStudentLevels[index],
                    );
                  },
                );
              } else {
                return Center(
                    child: Text(
                  "ضيف بعض المراحل",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions(context).fontSize(20)),
                ));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
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
      bottomNavigationBar: BottomBar(active: "home"),
    );
  }
}
