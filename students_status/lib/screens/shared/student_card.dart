import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_status/delete.dart';
import 'package:students_status/screens/shared/dimensions.dart';
import 'package:students_status/screens/student_edit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dropdown_menu/menu_item.dart';
import '../../dropdown_menu/menu_items.dart';

class CardStudent extends StatefulWidget {
  final Map student;
  final VoidCallback onDelete;
  const CardStudent({super.key, required this.student, required this.onDelete});

  @override
  State<CardStudent> createState() => _CardStudentState();
}

class _CardStudentState extends State<CardStudent> {
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
        print("===================== enterd");
        // Confirm(id: widget.student['student_id']);
        await showDeleteConfirmationDialog(
            context, widget.student['student_id'], widget.onDelete);
        break;
      case MenuItems.itemEdit:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditStudent(student: widget.student)));
        break;
      case MenuItems.itemChat:
        String message = ""; // Replace with your message
        String uri =
            'whatsapp://send?phone=+2${widget.student['phone']}&text=$message';

        final Uri url = Uri.parse(uri);

        if (!await launchUrl(url)) {
          throw Exception('Could not launch $url');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: Dimensions(context).width(17)),
            child: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(widget.student['name']),
              subtitle: Text(widget.student['phone']),
            ),
          ),
          // controller
          PopupMenuButton<MenuItem>(
            padding: EdgeInsets.zero,
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              ...MenuItems.itemsStudent.map(buildItem).toList(),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> showDeleteConfirmationDialog(
    BuildContext context, int studentId, onDelete) async {
  bool deleteConfirmed = await showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text("إزالة الطالب"),
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
    await Delete.deleteStudent(studentId);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("تم الحذف بنجاح")));
    onDelete();
  }
}
