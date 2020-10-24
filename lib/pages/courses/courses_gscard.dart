import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/pages/courses/categories/categories_page.dart';
import 'package:gradeslide/pages/courses/courses_gscard_gstrack.dart';

class GSCardCourse extends StatefulWidget {
  final Course course;
  final bool isEditMode;

  const GSCardCourse(this.course, this.isEditMode);

  @override
  _GSCardCourseState createState() => _GSCardCourseState();
}

class _GSCardCourseState extends State<GSCardCourse> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _animation;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 10, right: 8.0),
        child: FadeTransition(
          opacity: _animation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Card(
              elevation: 5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //Text(course.toJson().toString()),
                      Center(
                        child: Text(
                          widget.course.title,
                          textScaleFactor: 1.75,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GSTrackCourse(widget.course),
                      ),
                      //_buildCategoryOverview(db),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13, right: 13.0, bottom: 10.0),
                        child: Container(
                          height: 55,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                              child: Text(
                                "Enter Rubric",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesPage(widget.course)));
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.5))),
            ),
          ),
        ),
      ),
    );
  }
}
