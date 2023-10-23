import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:students_status/screens/profile.dart';
import 'package:students_status/screens/shared/dimensions.dart';

import '../sqldb.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final note = TextEditingController();

  SqlDb sqlDb = SqlDb();

  Future addLesson() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      int i = await sqlDb.insertData('''
        INSERT INTO notes (name, note) VALUES ('${name.text}', '${note.text}')
      ''');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfilePage()));
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
          child: Container(
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
                        return 'يجب ادخال اسم الملاحظة';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "أسم الملاحظة"),
                  ),
                  SizedBox(height: Dimensions(context).height(15)),
                  TextFormField(
                    controller: note,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'يجب ادخال محتوى الملاحظة';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "محتوى الملاحظة"),
                  ),
                  SizedBox(height: Dimensions(context).height(15)),
                  MaterialButton(
                    color: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text("أضف الملاحظة",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      addLesson();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
