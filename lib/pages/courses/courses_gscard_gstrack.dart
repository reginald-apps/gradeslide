import 'dart:async';
import 'dart:ui' as ui;

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
import 'package:gradeslide/pages/courses/courses_gscard_gstrack_title.dart';

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
  double courseGrade;
  double courseTarget;
  double courseMax;
  double zoomFactor;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();
    courseGrade = 0;
    courseTarget = 0;
    courseMax = 0;
    zoomFactor = 1;
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
    var db = DatabaseService();
    var weightAccepted = false;
    var totalWeight = 0.0;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    categoriesStream = db.streamCategories(widget.course.documentId);

    return StreamBuilder<List<Category>>(
      stream: categoriesStream,
      builder: (context, _) {
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
                  double width = constraints.maxWidth;
                  double borderRadius = 15;

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
                                border: Border.all(width: 2.5, color: isDarkMode ? Colors.black.withOpacity(.25) : Colors.white10.withOpacity(.15))),
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
                                    width: width,
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
                                        width: width,
                                      );
                                    }),
                                  ),
                                  AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, _) {
                                        double rowGrade = 0;
                                        double rowTarget = 0;
                                        double rowMax = 0;
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: categoriesInCourse.map((category) {
                                            return StreamBuilder<List<Work>>(
                                                stream: db.streamWorks(category.documentId),
                                                builder: (context, workListSnapshot) {
                                                  List<Work> works = [];
                                                  if (workListSnapshot.hasData) {
                                                    works = workListSnapshot.data;
                                                    rowMax += GradeSlideMaths.getCategoryMaximumTargetGrade(works) * category.weight;
                                                    rowGrade += GradeSlideMaths.getCategoryCompletedGrade(works, true) * category.weight;
                                                    rowTarget += GradeSlideMaths.getCategoryTargetGrade(works) * category.weight;
                                                    print(rowTarget);
                                                  }
                                                  if (workListSnapshot.connectionState == ConnectionState.waiting &&
                                                      categoriesSnapshot.connectionState == ConnectionState.waiting) {
                                                    courseMax = (rowMax * 100).round() / 100;
                                                    courseGrade = (rowGrade * 100).round() / 100;
                                                    courseTarget = (rowTarget * 100).round() / 100;
                                                  }
                                                  return Container();
                                                });
                                          }).toList(),
                                        );
                                      }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: categoriesInCourse.map((category) {
                                      return StreamBuilder<List<Work>>(
                                          stream: db.streamWorks(category.documentId),
                                          builder: (context, workListSnapshot) {
                                            List<Work> workList = [];
                                            if (workListSnapshot.hasData) {
                                              workList = workListSnapshot.data;
                                            }
                                            return AnimatedContainer(
                                              color: Colors.red,
                                              height: trackHeight,
                                              width: workList.isNotEmpty
                                                  ? width * zoomFactor * (1 - GradeSlideMaths.getCategoryMaximumTargetGrade(workList)) * category.weight
                                                  : 0,
                                              duration: Duration(milliseconds: 500),
                                              curve: Curves.ease,
                                            );
                                          });
                                    }).toList(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: categoriesInCourse.map((category) {
                                      return StreamBuilder<List<Work>>(
                                          stream: db.streamWorks(category.documentId),
                                          builder: (context, worksSnapshot) {
                                            List<Work> works = [];
                                            if (worksSnapshot.hasData) {
                                              works = worksSnapshot.data;
                                            }
                                            return AnimatedContainer(
                                              color: Colors.green,
                                              height: trackHeight,
                                              width:
                                                  works.isNotEmpty ? width / zoomFactor * (GradeSlideMaths.getCategoryCompletedGrade(works, true)) * category.weight : 0,
                                              duration: Duration(milliseconds: 500),
                                              curve: Curves.ease,
                                            );
                                          });
                                    }).toList(),
                                  ),
                                ])),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GSTrackCourseTitle(grade: courseGrade, target: courseTarget, max: courseMax),
                    ],
                  );
                }),
              );
            });
      },
    );
  }

  Widget _buildLine(double position, BoxConstraints constraints, Color color) {
    return CustomPaint(
      foregroundPainter: DiagnolLine(position, constraints, color),
    );
  }
}

class DiagnolLine extends CustomPainter {
  double _percentage;
  BoxConstraints _constraints;
  Color _color;

  DiagnolLine(this._percentage, this._constraints, this._color);

  @override
  void paint(Canvas canvas, Size size) {
    double startOffset = 0;
    if (_color == Colors.red) {
      startOffset = (_constraints.maxWidth) - (_constraints.maxWidth * _percentage) - 20;
    } else if (_color == Colors.green) {
      startOffset = 23 - (_constraints.maxWidth * _percentage);
    } else {
      startOffset = (_constraints.maxWidth / 2) - (_constraints.maxWidth * _percentage) + 8;
    }
    final pointMode = ui.PointMode.polygon;
    final points = [
      Offset(1, -14),
      Offset(0, 6),
    ];
    final paint = Paint()
      ..color = _color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
    final paint2 = Paint()
      ..color = _color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(ui.PointMode.polygon, points, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
