import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_status/delete.dart';
import 'package:students_status/screens/lesson_edit.dart';
import 'package:students_status/sqldb.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dropdown_menu/menu_item.dart';
import '../../dropdown_menu/menu_items.dart';
import 'dimensions.dart';

class CardLesson extends StatefulWidget {
  final Map lesson;

  final VoidCallback onDelete;
  const CardLesson({
    super.key,
    required this.lesson,
    required this.onDelete,
  });

  @override
  State<CardLesson> createState() => _CardLessonState();
}

class _CardLessonState extends State<CardLesson> {
  // int rate = 0;

  SqlDb sqlDb = SqlDb();

  List students = [];

  @override
  void initState() {
    super.initState();
  }

  void _sendWhatsAppMessage() async {
    String message = widget.lesson['link']; // Replace with your message
    List numbersToSendLink =
        students.map((student) => student['phone']).toList();
    for (String number in numbersToSendLink) {
      String uri = 'whatsapp://send?phone=+2$number&text=$message';

      final Uri url = Uri.parse(uri);

      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  Future feachStudents(String lessonId) async {
    List<Map> l = await sqlDb.readData(
        "SELECT * FROM `attendance` JOIN `students` ON attendance.student_id = students.student_id WHERE lesson_id = $lessonId");
    setState(() {
      students = l;
    });
    print(students);
    return "students";
  }

  void _showDialog(String lessonId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('جميع الحضور'),
          ),
          content: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: Dimensions(context).height(100),
            // color: Colors.blue,
            child: FutureBuilder(
              future: feachStudents(lessonId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (students.isNotEmpty) {
                    return Center(
                        child:
                            Text("يوجد ${students.length} طلاب حاضرين الدرس"));
                  } else {
                    return Center(child: Text("لا يوجد طلاب حاضرين هذا الدرس"));
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          actions: [
            MaterialButton(
              color: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text("ارسل الرابط للجميع",
                  style: TextStyle(color: Colors.white)),
              onPressed: () async {
                _sendWhatsAppMessage();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // dorpdown menu
  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, color: Colors.black, size: 20),
            SizedBox(width: 12),
            Text(item.text),
          ],
        ),
      );

  Future onSelected(BuildContext context, MenuItem item) async {
    switch (item) {
      case MenuItems.itemDelete:
        await showDeleteConfirmationDialog(
            context, widget.lesson['lesson_id'], widget.onDelete);
        break;
      case MenuItems.itemCopy:
        await FlutterClipboard.copy(widget.lesson['link']);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("تم نسخ الرابط الى الحافظة")));
        break;
      case MenuItems.itemEdit:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditLesson(lesson: widget.lesson)));
        break;
      case MenuItems.itemSend:
        _showDialog(widget.lesson['lesson_id'].toString());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        // width: double.infinity,
        // height: Dimensions.height(81),
        padding:
            EdgeInsets.symmetric(vertical: Dimensions(context).vertical(5)),
        margin:
            EdgeInsets.symmetric(vertical: Dimensions(context).vertical(11)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Color(0xFFE4E4E4)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(22, 0, 0, 0),
              offset: Offset(2, 4),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(widget.lesson['name']),
                subtitle: Text(widget.lesson['link']),
              ),
            ),
            // controller
            PopupMenuButton<MenuItem>(
              padding: EdgeInsets.zero,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                ...MenuItems.itemsLesson.map(buildItem).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showDeleteConfirmationDialog(
    BuildContext context, int lessonId, onDelete) async {
  bool deleteConfirmed = await showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text("إزالة الدرس"),
        content: Text("هل أنت متأكد"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text("لا"),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          CupertinoDialogAction(
            child: Text("نعم"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );

  if (deleteConfirmed) {
    await Delete.deleteLesson(lessonId);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("تم الحذف بنجاح")));
    onDelete();
  }
}
