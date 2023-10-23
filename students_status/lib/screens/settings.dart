import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:students_status/export-and-import/import.dart';
import 'package:students_status/screens/shared/BottomBar.dart';
import 'package:students_status/screens/shared/dimensions.dart';
import 'package:students_status/sqldb.dart';

import '../delete.dart';
import '../export-and-import/export.dart';
import 'add_course.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final studentName = TextEditingController();
  final studentPhone = TextEditingController();
  final levelName = TextEditingController();

  SqlDb sqlDb = SqlDb();

  String? levelId;
  List<Map> levels = [];

  Future getAllLevels() async {
    // print(sqlDb.insertData("INSERT INTO level (name) VALUES ('الصف الثالث')"));
    levels = await sqlDb.readData("SELECT * FROM `level`");

    print(levels);
    // List l = await sqlDb.readData("SELECT * FROM `students`");
    // print(l);
    return levels;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // getAllLevels();
  }

  Future addStudent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      int i = await sqlDb.insertData('''
        INSERT INTO students (name, phone, level_id) VALUES ('${studentName.text}', '${studentPhone.text}', $levelId)
      ''');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        // title: lang['success'],
        desc: "تم اضافة الطالب بنجاح",
      )..show();
      studentName.text = "";
      studentPhone.text = "";
      levelId = "";
      // print(sqlDb.readData("SELECT * FROM `students`"));
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        // title: lang['success'],
        desc: "الرجاء ادخال جميع البيانات",
      )..show();
    }
  }

  Future addLevel() async {
    if (_formKey2.currentState!.validate()) {
      _formKey2.currentState!.save();
      int i = await sqlDb.insertData('''
        INSERT INTO level (name) VALUES ('${levelName.text}')
      ''');
      levelName.text = "";
      // Navigator.of(context).pushReplacementNamed("settings");
      // print(sqlDb.readData("SELECT * FROM `students`"));
      setState(() {
        getAllLevels();
      });
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        // title: lang['success'],
        desc: "الرجاء ادخال جميع البيانات",
      )..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: Dimensions(context).height(100)),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: <Widget>[
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
                              "أضف طالب",
                              style: TextStyle(
                                //  fontWeight: FontWeight.bold,
                                fontSize: Dimensions(context).fontSize(15),
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "أضف مرحلة",
                              style: TextStyle(
                                // color: Colors.white,
                                fontSize: Dimensions(context).fontSize(15),
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "استيراد و تصدير",
                              style: TextStyle(
                                // color: Colors.white,
                                fontSize: Dimensions(context).fontSize(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: Dimensions(context).height(550),
                      width: double.infinity,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // add student
                          FutureBuilder(
                            future: getAllLevels(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions(context).horizontal(30),
                                    vertical: Dimensions(context).vertical(30),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: studentName,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'يجب ادخال اسم الطالب';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "أسم الطالب"),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions(context).height(15)),
                                        TextFormField(
                                          controller: studentPhone,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'يجب ادخال رقم الهاتف';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "رقم الهاتف"),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions(context).height(15)),
                                        FormHelper.dropDownWidget(
                                          context,
                                          "المرحلة",
                                          levelId,
                                          levels,
                                          (onChangedVal) {
                                            setState(() {
                                              levelId = onChangedVal;
                                              print(
                                                  "selected level is $levelId");
                                            });
                                          },
                                          (onValidateVal) {
                                            if (onValidateVal == null) {
                                              return "يجب أختيار مرحلة";
                                            }
                                            return null;
                                          },
                                          borderColor: Colors.grey,
                                          borderFocusColor:
                                              Theme.of(context).primaryColor,
                                          borderRadius: 6,
                                          paddingLeft: 0,
                                          paddingRight: 2,
                                          optionValue: "level_id",
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions(context).height(15)),
                                        MaterialButton(
                                          color: Colors.blueAccent,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 8),
                                          child: Text("أضف الطالب",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () async {
                                            addStudent();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                          // add level
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions(context).horizontal(30),
                              vertical: Dimensions(context).vertical(30),
                            ),
                            child: Column(
                              children: [
                                Form(
                                  key: _formKey2,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: levelName,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'يجب ادخال اسم المرحلة';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "أسم المرحلة"),
                                      ),
                                      SizedBox(
                                          height:
                                              Dimensions(context).height(15)),
                                      MaterialButton(
                                        color: Colors.blueAccent,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 8),
                                        child: Text("أضف المرحلة",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () async {
                                          addLevel();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: Dimensions(context).height(334),
                                  child: FutureBuilder(
                                    future: getAllLevels(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          // physics: NeverScrollableScrollPhysics(),
                                          itemCount: levels.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              child: ListTile(
                                                title:
                                                    Text(levels[index]['name']),
                                                trailing: CupertinoButton(
                                                  onPressed: () {
                                                    showCupertinoDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CupertinoAlertDialog(
                                                          title: Text(
                                                              "إزالة المرحلة"),
                                                          content: Text(
                                                              "هل أنت متأكد"),
                                                          actions: <
                                                              CupertinoDialogAction>[
                                                            CupertinoDialogAction(
                                                              child: Text("لا"),
                                                              isDestructiveAction:
                                                                  true,
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            CupertinoDialogAction(
                                                              child:
                                                                  Text("نعم"),
                                                              onPressed:
                                                                  () async {
                                                                await Delete.deleteLevel(
                                                                    levels[index]
                                                                        [
                                                                        'level_id']);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                setState(() {
                                                                  getAllLevels();
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors
                                                        .redAccent.shade100,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // export and import the data
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  onPressed: () async {
                                    await exportData();
                                  },
                                  child: Container(
                                    height: Dimensions(context).height(50),
                                    width: Dimensions(context).width(150),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "تصدير",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              Dimensions(context).fontSize(18)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: Dimensions(context).height(50)),
                                MaterialButton(
                                  onPressed: () {
                                    // Show the popup when the button is clicked
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PopupToImport(); // Use the custom popup widget
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: Dimensions(context).height(50),
                                    width: Dimensions(context).width(150),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "استيراد",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              Dimensions(context).fontSize(18)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: Dimensions(context).height(50)),
                                MaterialButton(
                                  onPressed: () {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text("حذف الجدول"),
                                          content: Text(
                                              "!هل أنت متأكد من حذف جميع البيانات الحالية"),
                                          actions: <CupertinoDialogAction>[
                                            CupertinoDialogAction(
                                              child: Text("لا"),
                                              isDestructiveAction: true,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            CupertinoDialogAction(
                                              child: Text("نعم"),
                                              onPressed: () async {
                                                await sqlDb.deleteDataBase();
                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.success,
                                                  animType:
                                                      AnimType.bottomSlide,
                                                  // title: lang['success'],
                                                  desc:
                                                      "تمت عملية الحذف بنجاح",
                                                )..show();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: Dimensions(context).height(50),
                                    width: Dimensions(context).width(150),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "مسح البيانات",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              Dimensions(context).fontSize(18)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),

        // the navebar
        floatingActionButton: FloatingActionButton(
          // heroTag: "btn1",
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
        bottomNavigationBar: BottomBar(active: "settings"),
      ),
    );
  }
}

class PopupToImport extends StatefulWidget {
  const PopupToImport({super.key});

  @override
  State<PopupToImport> createState() => _PopupToImportState();
}

class _PopupToImportState extends State<PopupToImport> {
  final _formKey = GlobalKey<FormState>();
  final text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions(context).horizontal(30),
        vertical: Dimensions(context).vertical(50),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: Dimensions(context).height(15)),
            TextFormField(
              maxLines: 5,
              controller: text,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'يجب ادخال النص';
                }
                return null;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "النص"),
            ),
            SizedBox(height: Dimensions(context).height(15)),
            MaterialButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text("اضافة الجدول"),
                        content: Text("هل أنت متأكد من تغيير البيانات الحالية"),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            child: Text("لا"),
                            isDestructiveAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text("نعم"),
                            onPressed: () async {
                              await importData(text.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.bottomSlide,
                                // title: lang['success'],
                                desc: "تمت عملية الاستيراد بنجاح",
                              )..show();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                height: Dimensions(context).height(50),
                width: Dimensions(context).width(150),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                alignment: Alignment.center,
                child: Text(
                  "استيراد",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions(context).fontSize(18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
