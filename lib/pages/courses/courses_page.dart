import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/gsloading.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/login/user.dart';
import 'package:gradeslide/pages/courses/courses_gscard.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CoursesPage extends StatefulWidget {
  CoursesPage();

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool isEditingMode;
  TapGestureRecognizer editingMode;

  @override
  void initState() {
    isEditingMode = false;
    editingMode = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          isEditingMode = !isEditingMode;
        });
      };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var db = DatabaseService();
    List<Course> courses = [];
    return Provider<User>(
        create: (_) => User(),
        builder: (context, _) {
          var user = Provider.of<User>(context);
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 65.0,
              title: Text(
                "Courses",
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      elevation: 5.0,
                      builder: (context) {
                        return Container(
                          height: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(15))),
                                height: 10,
                                width: 75,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "Create New Course",
                                  textScaleFactor: 1.5,
                                ),
                              ),
                              MaterialButton(
                                padding: EdgeInsets.zero,
                                child: buildCreateButton(MdiIcons.script, "Manual Setup"),
                                onPressed: () {
                                  print('?');
                                },
                              ),
                              MaterialButton(
                                padding: EdgeInsets.zero,
                                child: buildCreateButton(MdiIcons.earthArrowRight, "Transfer via Course Code"),
                                onPressed: () {
                                  print('?');
                                },
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
              actions: [
                Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: RichText(
                      text: TextSpan(
                        text: isEditingMode ? "Done" : "Edit",
                        style: TextStyle(decoration: TextDecoration.underline, fontSize: 16),
                        recognizer: editingMode,
                      ),
                    ))
              ],
            ),
            body: StreamBuilder<List<Course>>(
                stream: db.streamCourses(user.uid),
                builder: (context, semesterSnapshot) {
                  switch (semesterSnapshot.connectionState) {
                    case ConnectionState.active:
                      courses = semesterSnapshot.data;
                      return isEditingMode
                          ? ReorderableListView(
                              children: courses
                                  .map((e) => Container(
                                        key: ValueKey(e.documentId),
                                        child: Row(
                                          children: [
                                            Text(
                                              e.title,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.menu,
                                              size: 30,
                                            ),
                                            Divider()
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              onReorder: (one, two) {})
                          : ListView(children: courses.map((course) => GSCardCourse(course, isEditingMode)).toList());
                      break;
                    default:
                      return LoadingScreen("Loading Courses");
                  }
                }),
          );
        });
  }

  Widget buildCreateButton(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(icon),
              ),
              Container(
                color: Colors.grey,
                width: 1,
                height: 50,
              )
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            textScaleFactor: 1.25,
          )
        ],
      ),
    );
  }
}
