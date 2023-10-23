import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:students_status/screens/profile.dart';
import 'package:students_status/screens/shared/dimensions.dart';

import '../sqldb.dart';

class EditSchedule extends StatefulWidget {
  final List<Map> schedule;
  const EditSchedule({super.key, required this.schedule});

  @override
  State<EditSchedule> createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  final _formKey = GlobalKey<FormState>();
  final first1 = TextEditingController();
  final second1 = TextEditingController();
  final third1 = TextEditingController();
  final fourth1 = TextEditingController();
  final first2 = TextEditingController();
  final second2 = TextEditingController();
  final third2 = TextEditingController();
  final fourth2 = TextEditingController();
  final first3 = TextEditingController();
  final second3 = TextEditingController();
  final third3 = TextEditingController();
  final fourth3 = TextEditingController();
  final first4 = TextEditingController();
  final second4 = TextEditingController();
  final third4 = TextEditingController();
  final fourth4 = TextEditingController();
  final first5 = TextEditingController();
  final second5 = TextEditingController();
  final third5 = TextEditingController();
  final fourth5 = TextEditingController();
  final first6 = TextEditingController();
  final second6 = TextEditingController();
  final third6 = TextEditingController();
  final fourth6 = TextEditingController();
  final first7 = TextEditingController();
  final second7 = TextEditingController();
  final third7 = TextEditingController();
  final fourth7 = TextEditingController();

  SqlDb sqlDb = SqlDb();

  Future setSchedule() async {
    setState(() {
      first1.text = widget.schedule[0]['first'];
      second1.text = widget.schedule[0]['second'];
      third1.text = widget.schedule[0]['third'];
      fourth1.text = widget.schedule[0]['fourth'];
      first2.text = widget.schedule[1]['first'];
      second2.text = widget.schedule[1]['second'];
      third2.text = widget.schedule[1]['third'];
      fourth2.text = widget.schedule[1]['fourth'];
      first3.text = widget.schedule[2]['first'];
      second3.text = widget.schedule[2]['second'];
      third3.text = widget.schedule[2]['third'];
      fourth3.text = widget.schedule[2]['fourth'];
      first4.text = widget.schedule[3]['first'];
      second4.text = widget.schedule[3]['second'];
      third4.text = widget.schedule[3]['third'];
      fourth4.text = widget.schedule[3]['fourth'];
      first5.text = widget.schedule[4]['first'];
      second5.text = widget.schedule[4]['second'];
      third5.text = widget.schedule[4]['third'];
      fourth5.text = widget.schedule[4]['fourth'];
      first6.text = widget.schedule[5]['first'];
      second6.text = widget.schedule[5]['second'];
      third6.text = widget.schedule[5]['third'];
      fourth6.text = widget.schedule[5]['fourth'];
      first7.text = widget.schedule[6]['first'];
      second7.text = widget.schedule[6]['second'];
      third7.text = widget.schedule[6]['third'];
      fourth7.text = widget.schedule[6]['fourth'];
    });
  }

  @override
  void initState() {
    super.initState();
    setSchedule();
  }

  Future updateSchedule() async {
    _formKey.currentState!.save();

    String newFirst = first1.text;
    String newSecond = second1.text;
    String newThird = third1.text;
    String newFourth = fourth1.text;

    int i = await sqlDb.updateData(
      'UPDATE schedule SET first = ?, second = ?, third = ?, fourth = ? WHERE id = ${widget.schedule[0]['id']}',
      [newFirst, newSecond, newThird, newFourth],
    );

    newFirst = first2.text;
    newSecond = second2.text;
    newThird = third2.text;
    newFourth = fourth2.text;

    i = await sqlDb.updateData(
      'UPDATE schedule SET first = ?, second = ?, third = ?, fourth = ? WHERE id = ${widget.schedule[1]['id']}',
      [newFirst, newSecond, newThird, newFourth],
    );

    newFirst = first3.text;
    newSecond = second3.text;
    newThird = third3.text;
    newFourth = fourth3.text;

    i = await sqlDb.updateData(
      'UPDATE schedule SET first = ?, second = ?, third = ?, fourth = ? WHERE id = ${widget.schedule[2]['id']}',
      [newFirst, newSecond, newThird, newFourth],
    );

    newFirst = first4.text;
    newSecond = second4.text;
    newThird = third4.text;
    newFourth = fourth4.text;

    i = await sqlDb.updateData(
      'UPDATE schedule SET first = ?, second = ?, third = ?, fourth = ? WHERE id = ${widget.schedule[3]['id']}',
      [newFirst, newSecond, newThird, newFourth],
    );

    newFirst = first5.text;
    newSecond = second5.text;
    newThird = third5.text;
    newFourth = fourth5.text;

    i = await sqlDb.updateData(
      'UPDATE schedule SET first = ?, second = ?, third = ?, fourth = ? WHERE id = ${widget.schedule[4]['id']}',
      [newFirst, newSecond, newThird, newFourth],
    );

    newFirst = first6.text;
    newSecond = second6.text;
    newThird = third6.text;
    newFourth = fourth6.text;

    i = await sqlDb.updateData(
      'UPDATE schedule SET first = ?, second = ?, third = ?, fourth = ? WHERE id = ${widget.schedule[5]['id']}',
      [newFirst, newSecond, newThird, newFourth],
    );

    newFirst = first7.text;
    newSecond = second7.text;
    newThird = third7.text;
    newFourth = fourth7.text;

    i = await sqlDb.updateData(
      'UPDATE schedule SET first = ?, second = ?, third = ?, fourth = ? WHERE id = ${widget.schedule[6]['id']}',
      [newFirst, newSecond, newThird, newFourth],
    );

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions(context).horizontal(30),
                vertical: Dimensions(context).vertical(30),
              ),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Text(
                    "السبت",
                    style: TextStyle(
                      fontSize: Dimensions(context).fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions(context).height(10)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: first1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الأولى"),
                        ),
                      ),
                      SizedBox(width: Dimensions(context).width(15)),
                      Expanded(
                        child: TextFormField(
                          controller: second1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الثانية"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions(context).height(20)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: third1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الثالثة"),
                        ),
                      ),
                      SizedBox(width: Dimensions(context).width(15)),
                      Expanded(
                        child: TextFormField(
                          controller: fourth1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الرابعة"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions(context).height(30)),
                  Text(
                    "الأحد",
                    style: TextStyle(
                      fontSize: Dimensions(context).fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions(context).height(10)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: first2,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الأولى"),
                        ),
                      ),
                      SizedBox(width: Dimensions(context).width(15)),
                      Expanded(
                        child: TextFormField(
                          controller: second2,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الثانية"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions(context).height(20)),
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: third2,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الثالثة"),
                      ),
                    ),
                    SizedBox(width: Dimensions(context).width(15)),
                    Expanded(
                      child: TextFormField(
                        controller: fourth2,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الرابعة"),
                      ),
                    ),
                  ]),
                  SizedBox(height: Dimensions(context).height(30)),
                  Text(
                    "الأثنين",
                    style: TextStyle(
                      fontSize: Dimensions(context).fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions(context).height(10)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: first3,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الأولى"),
                        ),
                      ),
                      SizedBox(width: Dimensions(context).width(15)),
                      Expanded(
                        child: TextFormField(
                          controller: second3,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الثانية"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions(context).height(20)),
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: third3,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الثالثة"),
                      ),
                    ),
                    SizedBox(width: Dimensions(context).width(15)),
                    Expanded(
                      child: TextFormField(
                        controller: fourth3,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الرابعة"),
                      ),
                    ),
                  ]),
                  SizedBox(height: Dimensions(context).height(30)),
                  Text(
                    "الثلاثاء",
                    style: TextStyle(
                      fontSize: Dimensions(context).fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions(context).height(10)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: first4,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الأولى"),
                        ),
                      ),
                      SizedBox(width: Dimensions(context).width(15)),
                      Expanded(
                        child: TextFormField(
                          controller: second4,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الثانية"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions(context).height(20)),
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: third4,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الثالثة"),
                      ),
                    ),
                    SizedBox(width: Dimensions(context).width(15)),
                    Expanded(
                      child: TextFormField(
                        controller: fourth4,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الرابعة"),
                      ),
                    ),
                  ]),
                  SizedBox(height: Dimensions(context).height(30)),
                  Text(
                    "الأربعاء",
                    style: TextStyle(
                      fontSize: Dimensions(context).fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions(context).height(10)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: first5,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الأولى"),
                        ),
                      ),
                      SizedBox(width: Dimensions(context).width(15)),
                      Expanded(
                        child: TextFormField(
                          controller: second5,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الثانية"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions(context).height(20)),
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: third5,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الثالثة"),
                      ),
                    ),
                    SizedBox(width: Dimensions(context).width(15)),
                    Expanded(
                      child: TextFormField(
                        controller: fourth5,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الرابعة"),
                      ),
                    ),
                  ]),
                  SizedBox(height: Dimensions(context).height(30)),
                  Text(
                    "الخميس",
                    style: TextStyle(
                      fontSize: Dimensions(context).fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions(context).height(10)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: first6,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الأولى"),
                        ),
                      ),
                      SizedBox(width: Dimensions(context).width(15)),
                      Expanded(
                        child: TextFormField(
                          controller: second6,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الثانية"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions(context).height(20)),
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: third6,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الثالثة"),
                      ),
                    ),
                    SizedBox(width: Dimensions(context).width(15)),
                    Expanded(
                      child: TextFormField(
                        controller: fourth6,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الرابعة"),
                      ),
                    ),
                  ]),
                  SizedBox(height: Dimensions(context).height(30)),
                  Text(
                    "الجمعة",
                    style: TextStyle(
                      fontSize: Dimensions(context).fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions(context).height(10)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: first7,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الأولى"),
                        ),
                      ),
                      SizedBox(width: Dimensions(context).width(15)),
                      Expanded(
                        child: TextFormField(
                          controller: second7,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "الحصة الثانية"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions(context).height(20)),
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: third7,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الثالثة"),
                      ),
                    ),
                    SizedBox(width: Dimensions(context).width(15)),
                    Expanded(
                      child: TextFormField(
                        controller: fourth7,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "الحصة الرابعة"),
                      ),
                    ),
                  ]),
                  SizedBox(height: Dimensions(context).height(30)),
                  MaterialButton(
                    color: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text("حفظ الجدول",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      updateSchedule();
                    },
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
