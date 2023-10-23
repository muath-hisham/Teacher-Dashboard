import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:students_status/screens/add_note.dart';
import 'package:students_status/screens/edit_schedule.dart';
import 'package:students_status/screens/shared/BottomBar.dart';
import 'package:students_status/screens/shared/dimensions.dart';
import 'package:students_status/sqldb.dart';

import 'add_course.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> days = [
    'السبت',
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة'
  ];
  SqlDb sqlDb = SqlDb();
  List<Map> schedule = [];

  Future getAllNotes() async {
    List<Map> notes = await sqlDb.readData("SELECT * FROM notes");
    if (notes.isEmpty) {
      return 'empty';
    }
    return notes;
  }

  Future deleteNote(int id) async {
    int i = await sqlDb.deleteData("DELETE FROM notes WHERE id = $id");
    if (i != 0) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        // title: lang['success'],
        desc: "تم حذف الملاحظة بنجاح",
      )..show();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfilePage()));
    }
  }

  Future scheduleBilder() async {
    List<Map> s = await sqlDb.readData("SELECT * FROM schedule");
    if (s.length < 7) {
      for (int i = 0; i < 7; i++) {
        int i = await sqlDb.insertData(
            "INSERT INTO schedule (first, second, third, fourth) VALUES ('-','-','-','-')");
      }
      List<Map> s = await sqlDb.readData("SELECT * FROM schedule");
    }
    setState(() {
      schedule = s;
    });
    print(schedule);
  }

  Future delelete() async {
    sqlDb.deleteAll("schedule");
  }

  @override
  void initState() {
    super.initState();
    scheduleBilder();
    // delelete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: Dimensions(context).height(40)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "الجدول",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions(context).fontSize(20)),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EditSchedule(schedule: schedule)));
                        },
                        icon: Icon(Icons.edit, color: Colors.blue))
                  ],
                ),
                SizedBox(height: Dimensions(context).height(20)),
                Table(
                  // defaultColumnWidth: FixedColumnWidth(120.0),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.5),
                  children: [
                    TableRow(
                      children: [
                        Column(children: [
                          Text(
                            "اليوم",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),
                        Column(children: [
                          Text("الحصة الأولى",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                        Column(children: [
                          Text("الحصة الثانية",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                        Column(children: [
                          Text("الحصة الثالثة",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                        Column(children: [
                          Text("الحصة الرابعة",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ],
                    ),
                    for (int day = 0; day < schedule.length; day++)
                      TableRow(
                        children: [
                          Column(children: [
                            Text(days[day],
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions(context).vertical(5)),
                            child: Column(
                                children: [Text(schedule[day]['first'])]),
                          ),
                          Column(children: [Text(schedule[day]['second'])]),
                          Column(children: [Text(schedule[day]['third'])]),
                          Column(children: [Text(schedule[day]['fourth'])]),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: Dimensions(context).height(30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "الملاحظات",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions(context).fontSize(20)),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => AddNote()));
                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.orange,
                        size: Dimensions(context).fontSize(32),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: Dimensions(context).height(30)),
                Container(
                  height: Dimensions(context).height(280),
                  child: FutureBuilder(
                    future: getAllNotes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != 'empty') {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Row(children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text(snapshot.data[index]['name']),
                                      subtitle:
                                          Text(snapshot.data[index]['note']),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        deleteNote(snapshot.data[index]['id']);
                                      },
                                      icon: Icon(Icons.delete,
                                          color: Colors.redAccent))
                                ]),
                              );
                            },
                          );
                        } else {
                          return Center(child: Text("لا توجد ملاحظات"));
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
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
      bottomNavigationBar: BottomBar(active: "profile"),
    );
  }
}
