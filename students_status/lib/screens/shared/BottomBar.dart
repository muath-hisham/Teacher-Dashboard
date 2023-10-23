import 'package:flutter/material.dart';

import 'dimensions.dart';

class BottomBar extends StatefulWidget {
  final String active;

  const BottomBar({super.key, required this.active});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool home = false;
  bool attendance = false;
  bool settings = false;
  bool profile = false;

  @override
  _BottomBarState();

  whoIsActive() {
    if (widget.active == "home") {
      home = true;
    } else if (widget.active == "attendance") {
      attendance = true;
    } else if (widget.active == "settings") {
      settings = true;
    } else if (widget.active == "profile") {
      profile = true;
    }
  }

  @override
  void initState() {
    super.initState();
    whoIsActive();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.transparent,
        elevation: 9.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: Dimensions(context).height(70),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
              color: Colors.white),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              height: Dimensions(context).height(50),
              width: Dimensions(context).width(155),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("home");
                      },
                      icon:
                          (home) ? Icon(Icons.home) : Icon(Icons.home_outlined),
                      color: (home) ? Colors.blueAccent : Colors.black),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("attendance");
                    },
                    icon: (attendance)
                        ? Icon(Icons.person_add)
                        : Icon(Icons.person_add_outlined),
                    color: (attendance) ? Colors.blueAccent : Colors.black,
                  ),
                ],
              ),
            ),
            Container(
              height: Dimensions(context).height(50),
              width: Dimensions(context).width(155),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("profile");
                    },
                    icon: (profile)
                        ? Icon(Icons.person)
                        : Icon(Icons.person_outline),
                    color: (profile) ? Colors.blueAccent : Colors.black,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("settings");
                    },
                    icon: (settings)
                        ? Icon(Icons.settings)
                        : Icon(Icons.settings_outlined),
                    color: (settings) ? Colors.blueAccent : Colors.black,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
