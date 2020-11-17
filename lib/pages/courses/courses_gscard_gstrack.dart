import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/logic/gsmaths.dart';
import 'package:gradeslide/pages/courses/courses_gscard_gstrack_marker.dart';
import 'package:gradeslide/pages/courses/courses_gscard_gstrack_title.dart';
import 'package:provider/provider.dart';

class GSTrackCourse extends StatefulWidget {
  final Course course;

  const GSTrackCourse(this.course);

  @override
  _GSTrackCourseState createState() => _GSTrackCourseState();
}

class _GSTrackCourseState extends State<GSTrackCourse> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _animation;
  Stream categoriesStream;
  double courseCurrent;
  double courseCurrentLost;
  double courseTarget;
  double courseMax;
  double zoomFactor;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();
    courseCurrent = 0;
    courseTarget = 0;
    courseCurrentLost = 0;
    courseMax = 0;
    zoomFactor = 1;
    switch (_animation.status) {
      case AnimationStatus.completed:
        setState(() {});
        break;
      case AnimationStatus.dismissed:
        break;
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.forward:
        break;
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    zoomFactor = 1;
    DatabaseService db = Provider.of<DatabaseService>(context);
    var weightAccepted = false;
    var totalWeight = 0.0;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 100)),
      builder: (context, snapshot) {
        return StreamBuilder<List<Category>>(
            stream: db.streamCategories(widget.course.documentId),
            builder: (context, categoriesSnapshot) {
              List<Category> categoriesInCourse = [];
              if (categoriesSnapshot.hasData) {
                categoriesInCourse = categoriesSnapshot.data;
                if (categoriesInCourse != null) {
                  categoriesInCourse.sort((cat1, cat2) {
                    var cat1Weight = cat1.weight;
                    var cat2Weight = cat2.weight;
                    return ((cat1Weight > cat2Weight) ? -1 : ((cat1Weight < cat2Weight) ? 1 : 0));
                  });
                }
              }
              totalWeight = 0;
              categoriesInCourse.forEach((element) {
                totalWeight += element.weight;
              });
              if ((totalWeight * 100).round() / 100 == 1.0) {
                weightAccepted = true;
              }
              return Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 0, bottom: 0, right: 15.0),
                child: LayoutBuilder(builder: (context, constraints) {
                  double trackHeight = 15; //TODO: iPhone: 15, Tablet: 30
                  double trackLength = constraints.maxWidth;
                  double borderRadius = 15;
                  double rowGrade = 0;
                  double rowTarget = 0;
                  double rowMax = 0;
                  return Column(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Container(
                            foregroundDecoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                                backgroundBlendMode: BlendMode.color,
                                border: Border.all(width: 2.5, color: isDarkMode ? Colors.white.withOpacity(.25) : Colors.white10.withOpacity(.15))),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(borderRadius),
                                child: Stack(children: <Widget>[
                                  Container(
                                    foregroundDecoration: BoxDecoration(
                                      color: weightAccepted ? Colors.transparent : Colors.grey,
                                      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                                    ),
                                    child: Container(
                                      color: Colors.orange,
                                    ),
                                    height: trackHeight,
                                    width: trackLength,
                                  ),
                                  FadeTransition(
                                    opacity: _animation,
                                    child: FlareCacheBuilder([AssetFlare(bundle: rootBundle, name: "flares/progbar.flr")], builder: (context, isWarm) {
                                      return Container(
                                        foregroundDecoration: BoxDecoration(
                                          color: weightAccepted ? Colors.transparent : Colors.grey,
                                          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                                          backgroundBlendMode: weightAccepted ? BlendMode.saturation : BlendMode.color,
                                        ),
                                        child: FlareActor(
                                          "flares/progbar.flr",
                                          fit: BoxFit.cover,
                                          animation: "Progress",
                                        ),
                                        height: trackHeight,
                                        width: trackLength,
                                      );
                                    }),
                                  ),
                                  Row(
                                    children: categoriesInCourse.map((category) {
                                      return StreamBuilder<List<Work>>(
                                          stream: db.streamWorks(category.documentId),
                                          builder: (context, workListSnapshot) {
                                            List<Work> workList = [];
                                            if (workListSnapshot.hasData) {
                                              workList = workListSnapshot.data;
                                            }
                                            if (workListSnapshot.hasData) {
                                              List<Work> works = [];
                                              works = workListSnapshot.data;
                                              if (categoriesSnapshot.connectionState != ConnectionState.active &&
                                                  workListSnapshot.connectionState != ConnectionState.active) {
                                                rowMax += GradeSlideMaths.getCategoryMaximumTargetGrade(works) * category.weight;
                                                rowGrade += GradeSlideMaths.getCategoryCompletedGrade(works, true) * category.weight;
                                                rowTarget += GradeSlideMaths.getCategoryTargetGrade(works) * category.weight;
                                                courseMax = (rowMax * 100).round() / 100;
                                                courseCurrentLost = 1 - (rowMax * 100).round() / 100;
                                                courseCurrent = (rowGrade * 100).round() / 100;
                                                courseTarget = (rowTarget * 100).round() / 100;
                                              }
                                            }
                                            return Container();
                                          });
                                    }).toList(),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 1000),
                                      curve: Curves.ease,
                                      color: Colors.red,
                                      height: trackHeight,
                                      width: trackLength * (courseCurrentLost),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 1000),
                                      curve: Curves.ease,
                                      color: Colors.green,
                                      height: trackHeight,
                                      width: trackLength * (courseCurrent),
                                    ),
                                  ),
                                ])),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      GSTrackCourseTitle(grade: courseCurrent, target: courseTarget, max: courseMax),
                    ],
                  );
                }),
              );
            });
      },
    );
  }
}
