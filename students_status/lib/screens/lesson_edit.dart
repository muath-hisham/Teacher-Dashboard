import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:students_status/screens/level_details.dart';
import 'package:students_status/screens/shared/dimensions.dart';
import 'package:students_status/sqldb.dart';

class EditLesson extends StatefulWidget {
  final Map lesson;
  const EditLesson({super.key, required this.lesson});

  @override
  State<EditLesson> createState() => _EditLessonState();
}

class _EditLessonState extends State<EditLesson> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final link = TextEditingController();

  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    super.initState();
    setState(() {
      name.text = widget.lesson['name'];
      link.text = widget.lesson['link'];
    });
  }

 Future<void> editLesson() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    int lessonId = widget.lesson['lesson_id'];
    String newName = name.text;
    String newLink = link.text;

    int i = await sqlDb.updateData(
      'UPDATE lesson SET name = ?, link = ? WHERE lesson_id = ?',
      [newName, newLink, lessonId],
    );

    Navigator.of(context).pop();
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
          height: Dimensions(context).height(330),
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions(context).horizontal(30),
            vertical: Dimensions(context).vertical(30),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'يجب ادخال اسم الدرس';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "أسم الدرس"),
                ),
                SizedBox(height: Dimensions(context).height(15)),
                TextFormField(
                  controller: link,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'يجب ادخال الرابط';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "الرابط"),
                ),
                SizedBox(height: Dimensions(context).height(15)),
                MaterialButton(
                  color: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child:
                      Text("حفظ التعديل", style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    editLesson();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
