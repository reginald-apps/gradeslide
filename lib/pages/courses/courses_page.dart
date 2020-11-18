import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/gsloading.dart';
import 'package:gradeslide/gssettings.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/courses_gscard.dart';
import 'package:gradeslide/pages/courses/courses_setup_step1.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CoursesPage extends StatefulWidget {
  CoursesPage();

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> with SingleTickerProviderStateMixin {
  bool isEditingMode;
  bool isSortMode;
  List<Course> courses;
  AnimationController _controller;
  Animation _animation;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    isEditingMode = false;
    isSortMode = false;
    courses = [];
    _controller = AnimationController(duration: Duration(seconds: 3), vsync: this)..forward();
    _animation = new Tween<double>(begin: 0.0, end: 1.0).animate(new CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      drawer: Drawer(elevation: 0, child: SettingsPage()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCourseCreation(context);
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        isExtended: true,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      appBar: AppBar(
        toolbarHeight: 55.0,
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
            onPressed: () {
              setState(() {
                isSortMode = !isSortMode;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditingMode = !isEditingMode;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Course>>(
          stream: db.streamCourses(user.uid),
          builder: (context, coursesSnapshot) {
            return FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 300)),
                builder: (context, loadingScreenSnapshot) {
                  if (loadingScreenSnapshot.connectionState != ConnectionState.done) {
                    return LoadingScreen("Loading Courses");
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
                            buildFirstCourseButton("Try Sample Course", 1, () => db.addSampleCourse(user)),
                            buildFirstCourseButton("Manually Enter Rubric", 2, () {}),
                            buildFirstCourseButton("Transfer Course via Course Code", 3, () {}),
                            SizedBox(
                              height: 70,
                            )
                          ],
                        ))
                      : !isEditingMode
                          ? ListView(
                              //physics: AlwaysScrollableScrollPhysics(),
                              children: coursesSnapshot.hasData
                                  ? coursesSnapshot.data
                                      .asMap()
                                      .entries
                                      .map((course) => GSCardCourse(ValueKey(course.value.documentId), course.value, isEditingMode))
                                      .toList()
                                  : [])
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
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CourseSetup1()));
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
                MaterialButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        buildCourseCreateButton(context, MdiIcons.earthArrowRight, "Transfer via Course Code"),
                      ],
                    )),
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
