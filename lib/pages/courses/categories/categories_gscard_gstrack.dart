import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/logic/gsmaths.dart';

class GSTrackCategory extends StatefulWidget {
  final Category category;

  GSTrackCategory(this.category);

  @override
  _GSTrackCategoryState createState() => _GSTrackCategoryState();
}

class _GSTrackCategoryState extends State<GSTrackCategory> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _animation;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var db = DatabaseService();
    Category category = widget.category;
    double height = 15; //TODO: iPhone: 15, Tablet: 22
    double goalSize = 1.5;
    return AnimatedBuilder(
        builder: (context, _) {
          return StreamBuilder<List<Work>>(
              stream: db.streamWorks(category.documentId),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? LayoutBuilder(builder: (context, constraints) {
                        double trackLength = constraints.maxWidth * _animation.value;
                        double completedStart = 0;
                        double completedWidth = category.weight * trackLength * GradeSlideMaths.getCategoryCompletedGrade(snapshot.data, false);

                        double targetStart = 0;
                        double targetWidth = category.weight * trackLength * GradeSlideMaths.getCategoryTargetGrade(snapshot.data);

                        double maximumWidth = (1 - GradeSlideMaths.getCategoryMaximumTargetGrade(snapshot.data)) * trackLength * category.weight;

                        double progressStart = 0;
                        double progressEnd = category.weight * trackLength;

                        double animationProgress = _animation.value;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: trackLength * category.weight,
                                foregroundDecoration: Theme.of(context).brightness == Brightness.dark
                                    ? BoxDecoration(
                                        border: Border.all(width: 2.5, color: Colors.black.withOpacity(.25)), borderRadius: BorderRadius.all(Radius.circular(15)))
                                    : BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        backgroundBlendMode: BlendMode.lighten,
                                        border: Border.all(width: 3, color: Colors.white.withOpacity(.2))),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.bounceOut,
                                        color: Colors.black.withOpacity(.10),
                                        height: height,
                                        width: trackLength,
                                        child: Container(),
                                      ),
                                    ),
                                    Positioned(
                                      left: completedStart,
                                      child: ClipPath(
                                        clipper: ProgressClipper(width: (category.weight) * trackLength),
                                        child: FlareActor(
                                          "flares/progbar.flr",
                                          fit: BoxFit.cover,
                                          animation: "Progress",
                                        ),
                                      ),
                                      height: height,
                                      width: trackLength,
                                    ),
                                    Positioned(
                                      left: completedStart,
                                      child: AnimatedContainer(
                                        color: Colors.green,
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.ease,
                                        height: height,
                                        width: completedWidth * animationProgress,
                                      ),
                                    ),
                                    Positioned(
                                      right: (trackLength * category.weight) - progressStart - progressEnd,
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.ease,
                                        color: Colors.red,
                                        height: height,
                                        width: (maximumWidth * animationProgress),
                                      ),
                                    ),
                                  ],
                                ),
                              ), /*
                              Positioned(
                                left: targetStart - 4 + targetWidth * animationProgress,
                                child: AnimatedContainer(duration: Duration(seconds: 1), child: GSTrackCategoryMarker(0.0, height + 2)),
                              ),*/
                            ],
                          ),
                        );
                      })
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: LayoutBuilder(builder: (context, constraints) {
                              double width = constraints.maxWidth;
                              return Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: Container(
                                      color: Colors.black.withOpacity(.10),
                                      height: 20,
                                      width: width,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      );
              });
        },
        animation: _animation);
  }
}

class ProgressClipper extends CustomClipper<Path> {
  double width;

  ProgressClipper({this.width});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(width, 0.0);
    path.lineTo(width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
