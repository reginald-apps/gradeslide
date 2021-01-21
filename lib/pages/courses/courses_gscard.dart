import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/course_gscard_workstory_highlight.dart';
import 'package:gradeslide/pages/courses/courses_gscard_gstrack.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../gradeslide_page.dart';

class GSCardCourse extends StatefulWidget {
  final Key key;
  final Course course;
  final bool isEditMode;
  final bool isOverview;
  final bool isAddCard;

  const GSCardCourse(this.key, this.course, this.isEditMode, this.isOverview, this.isAddCard) : super(key: key);

  @override
  _GSCardCourseState createState() => _GSCardCourseState();
}

class _GSCardCourseState extends State<GSCardCourse> with TickerProviderStateMixin {
  AnimationController _startUpController;
  AnimationController _startSizeController;
  CurvedAnimation _startUpAnimation;
  Animation<double> _sizeAnimation;
  Animation<Offset> _offsetAnimation;
  bool isShowMore = false;
  Work selectedWork;
  Category selectedCategory;

  @override
  void initState() {
    _startUpController = AnimationController(duration: Duration(milliseconds: 1250), vsync: this);
    _startSizeController = AnimationController(duration: Duration(milliseconds: 400), vsync: this);

    _startUpAnimation = CurvedAnimation(parent: _startUpController, curve: Curves.fastOutSlowIn);

    _sizeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _startSizeController,
      curve: Curves.easeOutBack,
    ));

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _startUpController,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    _startUpController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _startUpController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    //print('\n');
    bool isOverview = widget.isOverview;
    DatabaseService db = Provider.of<DatabaseService>(context);
    return widget.isAddCard
        ? InkWell(
            onTap: () {
              showCourseCreation(context);
            },
            child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                color: Colors.grey.withOpacity(.35),
                borderOnForeground: true,
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 5), borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add New Course",
                          style: TextStyle(color: Colors.white.withOpacity(1), fontSize: 10),
                        ),
                        Icon(
                          Icons.add,
                          color: Colors.white.withOpacity(.5),
                          size: 12.5,
                        ),
                      ],
                    ),
                  ),
                )),
          )
        : Padding(
            padding: isOverview ? EdgeInsets.only(left: 0.0, bottom: 0, right: 0.0) : EdgeInsets.only(left: 8.0, right: 8.0),
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => GradeSlidePage(ValueKey(widget.course.documentId), widget.course, false)));
              },
              child: FadeTransition(
                opacity: _startUpAnimation,
                child: Card(
                  elevation: 5,
                  color: Theme.of(context).cardColor.withOpacity(.90),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              widget.course.title,
                              textScaleFactor: isOverview ? 1.25 : 1.75,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: GSTrackCourse(course: widget.course, animatedStart: true, isOverview: true),
                            ),
                            Expanded(
                                child: CourseCardRubricOverview(
                              course: widget.course,
                              onPickerChanged: () {
                                setState(() {});
                              },
                              isOverview: true,
                            )),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(side: BorderSide(width: 5, color: Colors.black12), borderRadius: BorderRadius.all(Radius.circular(7.5))),
                ),
              ),
            ),
          );
  }
}

List<Category> _sort(List<Category> categories) {
  categories.sort((a, b) {
    if (a.index < b.index) {
      return -1;
    } else if (a.index > b.index) {
      return 1;
    } else {
      if (a.weight < b.weight) {
        return 1;
      } else if (a.weight > b.weight) {
        return -1;
      } else {
        if (!a.name.toLowerCase().compareTo(b.name.toLowerCase().toString()).isNegative) {
          return 1;
        } else if (a.name.toLowerCase().compareTo(b.name.toLowerCase().toString()).isNegative) {
          return -1;
        } else {
          return 0;
        }
      }
    }
  });
  return categories;
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
