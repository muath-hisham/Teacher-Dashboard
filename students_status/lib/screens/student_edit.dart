import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:students_status/screens/level_details.dart';
import 'package:students_status/screens/shared/dimensions.dart';
import 'package:students_status/sqldb.dart';

class EditStudent extends StatefulWidget {
  final Map student;
  const EditStudent({super.key, required this.student});

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final _formKey = GlobalKey<FormState>();
  final studentName = TextEditingController();
  final studentPhone = TextEditingController();

  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    super.initState();
    setState(() {
      studentName.text = widget.student['name'];
      studentPhone.text = widget.student['phone'];
    });
  }

 Future<void> editStudent() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    int studentId = widget.student['student_id'];
    String newName = studentName.text;
    String newPhone = studentPhone.text;

    int i = await sqlDb.updateData(
      'UPDATE students SET name = ?, phone = ? WHERE student_id = ?',
      [newName, newPhone, studentId],
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
                  controller: studentName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'يجب ادخال اسم الطالب';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "أسم الطالب"),
                ),
                SizedBox(height: Dimensions(context).height(15)),
                TextFormField(
                  controller: studentPhone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'يجب ادخال رقم الهاتف';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "رقم الهاتف"),
                ),
                SizedBox(height: Dimensions(context).height(15)),
                MaterialButton(
                  color: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child:
                      Text("حفظ التعديل", style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    editStudent();
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
