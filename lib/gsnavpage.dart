import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/gssettings.dart';
import 'package:gradeslide/pages/agenda/agenda_page.dart';
import 'package:gradeslide/pages/courses/courses_page.dart';

class GradeSlideNavPage extends StatefulWidget {
  GradeSlideNavPage();

  @override
  _GradeSlideNavPageState createState() => _GradeSlideNavPageState();
}

class _GradeSlideNavPageState extends State<GradeSlideNavPage> {
  bool isEditingMode;
  int currentScreen;
  List<Widget> screens;

  @override
  void initState() {
    isEditingMode = false;
    currentScreen = 1;
    screens = [
      AgendaPage(),
      CoursesPage(),
      SettingsPage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return screens[currentScreen];
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentScreen,
        onTap: (screenId) {
          setState(() {
            currentScreen = screenId;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
                size: 18,
              ),
              title: Text("Agenda")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.library_books,
              ),
              title: Text("Courses")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 18,
              ),
              title: Text("Settings")),
        ],
      ),
    );
  }
}
