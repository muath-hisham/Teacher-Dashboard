import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:students_status/screens/shared/dimensions.dart';

import '../sqldb.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final _formKey = GlobalKey<FormState>();
  final lessonName = TextEditingController();
  final lessonLink = TextEditingController();

  SqlDb sqlDb = SqlDb();

  String? levelId;
  List<Map> levels = [];

  Future getAllLevels() async {
    levels = await sqlDb.readData("SELECT * FROM `level`");
    print(levels);
    return levels;
  }

  Future addLesson() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      int i = await sqlDb.insertData('''
        INSERT INTO lesson (name, link, level_id) VALUES ('${lessonName.text}', '${lessonLink.text}', $levelId)
      ''');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        // title: lang['success'],
        desc: "تم اضافة الدرس بنجاح",
      )..show();
      lessonName.text = "";
      lessonLink.text = "";
      levelId = "";
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
    return Scaffold(
      body: Center(
        child: Container(
          height: Dimensions(context).height(420),
          child: FutureBuilder(
            future: getAllLevels(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions(context).horizontal(30),
                    vertical: Dimensions(context).vertical(30),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: lessonName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'يجب ادخال اسم الدرس';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "أسم الدرس"),
                        ),
                        SizedBox(height: Dimensions(context).height(15)),
                        TextFormField(
                          controller: lessonLink,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'يجب ادخال رابط الدرس';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "رابط الدرس"),
                        ),
                        SizedBox(height: Dimensions(context).height(15)),
                        FormHelper.dropDownWidget(
                          context,
                          "المرحلة",
                          levelId,
                          levels,
                          (onChangedVal) {
                            setState(() {
                              levelId = onChangedVal;
                              print("selected level is $levelId");
                            });
                          },
                          (onValidateVal) {
                            if (onValidateVal == null) {
                              return "يجب أختيار مرحلة";
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
                        SizedBox(height: Dimensions(context).height(15)),
                        MaterialButton(
                          color: Colors.blueAccent,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Text("أضف الدرس",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            addLesson();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
