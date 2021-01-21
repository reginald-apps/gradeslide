import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradeslide/gssettings.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/courses_gscard.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CoursesPage extends StatefulWidget {
  CoursesPage();

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  bool _isEditingMode;
  bool _isSortMode;
  Course _selectedCourse;

  @override
  void initState() {
    _isEditingMode = false;
    _isSortMode = false;
    _controller = AnimationController(duration: Duration(seconds: 3), vsync: this)..forward();
    _animation = new Tween<double>(begin: 0.0, end: 1.0).animate(new CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: Drawer(elevation: 0, child: SettingsPage()),
      appBar: AppBar(
        toolbarHeight: 45.0,
        title: Text(
          "Courses",
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(builder: (buttonContext) {
          return IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Scaffold.of(buttonContext).openDrawer();
            },
          );
        }),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            splashRadius: 15,
            onPressed: () {
              setState(() {
                _isEditingMode = !_isEditingMode;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: 20,
            ),
            splashRadius: 15,
            onPressed: () {
              setState(() {
                _isSortMode = !_isSortMode;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Course>>(
          stream: db.streamCourses(user.uid),
          builder: (context, coursesSnapshot) {
            return FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 0)),
                builder: (context, loadingScreenSnapshot) {
                  if (loadingScreenSnapshot.connectionState != ConnectionState.done) {
                    return Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 5,
                    ));
                  }
                  return coursesSnapshot.hasData && coursesSnapshot.data.length == 0
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeTransition(
                              opacity: _animation,
                              child: Text(
                                "Add Your First Course!",
                                textScaleFactor: 2.75,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.amber),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            buildFirstCourseButton("Try Sample Course", 1, () {
                              db.addSampleChemistryCourse(user);
                              db.addSampleMathCourse(user);
                              db.addAndrewCourse(user);
                            }),
                            buildFirstCourseButton("Manually Enter Rubric", 2, () {}),
                            //buildFirstCourseButton("Import Course via Course Code", 3, () {}),
                            SizedBox(
                              height: 70,
                            )
                          ],
                        ))
                      : !_isEditingMode
                          ? coursesSnapshot.data != null
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5.0, left: 12.5, right: 12.5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.search,
                                                    color: Colors.white.withOpacity(.5),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "Search",
                                                  style: TextStyle(color: Colors.white.withOpacity(.2), fontFamily: "Montserrat-Light"),
                                                )
                                              ],
                                            ),
                                            Container(
                                              height: 40,
                                              color: Colors.grey.withOpacity(isDark ? .05 : .2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                        padding: EdgeInsets.only(left: 10, right: 10, top: 5.0),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                          crossAxisCount: 2,
                                          childAspectRatio: 1 / 1.5,
                                        ),
                                        itemCount: coursesSnapshot.data.length + 1,
                                        itemBuilder: (BuildContext context, int index) {
                                          if (index == coursesSnapshot.data.length) {
                                            return GSCardCourse(ValueKey(""), null, false, true, true);
                                          } else
                                            return GSCardCourse(ValueKey(coursesSnapshot.data[index]), coursesSnapshot.data[index], false, true, false);
                                        },
                                      ),
                                    )
                                  ],
                                )
                              : Center(child: CircularProgressIndicator())
                          : ReorderableListView(
                              children: coursesSnapshot.hasData
                                  ? coursesSnapshot.data
                                      .map((course) => ListTile(
                                            key: ValueKey(course.documentId),
                                            title: Text(
                                              course.title,
                                              style: Theme.of(context).textTheme.bodyText2,
                                            ),
                                            trailing: Icon(Icons.menu),
                                            tileColor: Theme.of(context).cardColor,
                                          ))
                                      .toList()
                                  : [],
                              onReorder: (i, e) {});
                });
          }),
    );
  }

  void showCourseCreation(BuildContext context) {
    showModalBottomSheet(
        context: context,
        elevation: 5.0,
        builder: (context) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
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
                Container(decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(15))), height: 7.5, width: 60),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Create New Course",
                    textScaleFactor: 1.5,
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 2,
                ),
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildCourseCreateButton(context, MdiIcons.script, "Manual Setup"),
                        Divider(
                          indent: 45,
                          thickness: 1,
                          height: 0,
                        ),
                      ],
                    )),
                /* MaterialButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        buildCourseCreateButton(context, MdiIcons.earthArrowRight, "Import via Course Code"),
                      ],
                    )),*/
              ],
            ),
          );
        });
  }

  Widget buildCourseCreateButton(BuildContext context, IconData icon, String title) {
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).textTheme.subtitle1.color,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            textScaleFactor: 1.25,
            style: Theme.of(context).textTheme.subtitle1,
          )
        ],
      ),
    );
  }

  Widget buildFirstCourseButton(String title, int index, VoidCallback onPressed) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.0, index.toDouble() * 2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.fastLinearToSlowEaseIn,
        )),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: 325,
              height: 100,
              child: FlatButton(
                onPressed: onPressed,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white),
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.center,
                ),
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
