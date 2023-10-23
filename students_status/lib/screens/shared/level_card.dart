import 'package:flutter/material.dart';
import '../level_details.dart';
import 'dimensions.dart';

class CardLevel extends StatelessWidget {
  final Map level;
  final int noStudents;
  final int noLessons;
  const CardLevel({
    super.key,
    required this.level,
    required this.noStudents,
    required this.noLessons,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          Expanded(
            child: Container(
              // width: double.infinity,
              // height: Dimensions.height(81),
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions(context).vertical(15)),
              margin: EdgeInsets.symmetric(
                  vertical: Dimensions(context).vertical(20)),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Color(0xFFE4E4E4)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(22, 0, 0, 0),
                      offset: Offset(2, 4),
                      blurRadius: 5)
                ],
              ),
              // margin: EdgeInsets.symmetric(horizontal: Dimensions.vertical(30)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LevelDetails(level: level),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      level['name'],
                      style:
                          TextStyle(fontSize: Dimensions(context).fontSize(18)),
                    ),
                    Column(
                      children: [
                        Text("عدد الدروس"),
                        Text(noLessons.toString())
                      ],
                    ),
                    Column(
                      children: [
                        Text("عدد الطلاب"),
                        Text(noStudents.toString())
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
