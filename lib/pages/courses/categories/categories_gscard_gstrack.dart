import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/logic/gsmaths.dart';
import 'package:provider/provider.dart';

class GSTrackCategory extends StatefulWidget {
  final Category category;
  final bool startAnimated;
  final Function(List<Work>) getPoints;
  final bool isOverview;

  GSTrackCategory(this.category, this.startAnimated, this.getPoints, this.isOverview);

  @override
  _GSTrackCategoryState createState() => _GSTrackCategoryState();
}

class _GSTrackCategoryState extends State<GSTrackCategory> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _animation;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: widget.startAnimated ? 1000 : 1000), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.startAnimated ? Curves.elasticOut : Curves.fastOutSlowIn);
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
    DatabaseService db = Provider.of<DatabaseService>(context);
    Category category = widget.category;
    double trackHeight = widget.isOverview ? 8 : 15; //TODO: iPhone: 15, Tablet: 22
    return AnimatedBuilder(
        builder: (context, _) {
          return StreamBuilder<List<Work>>(
              stream: db.streamWorks(category.documentId),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? LayoutBuilder(builder: (context, constraints) {
                        double trackLength = constraints.maxWidth * _animation.value;
                        double completedStart = 0;
                        double completedWidth = category.weight * trackLength * GradeSlideMaths.getCategoryCompletedGrade(snapshot.data, false)[0];
                        double targetWidth = category.weight * trackLength * GradeSlideMaths.getCategoryTargetGrade(snapshot.data)[0];
                        double maximumWidth = (1 - GradeSlideMaths.getCategoryMaximumTargetGrade(snapshot.data)[0]) * trackLength * category.weight;
                        double animationProgress = _animation.value;
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          //widget.getPoints.call(snapshot.data);
                          //print(snapshot.data);
                        }
                        return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Stack(
                            alignment: Alignment.center,
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Container(
                                width: trackLength * category.weight,
                                height: trackHeight,
                                foregroundDecoration: Theme.of(context).brightness == Brightness.dark
                                    ? BoxDecoration(
                                        border: Border.all(width: 2.5, color: Colors.white.withOpacity(.25)), borderRadius: BorderRadius.all(Radius.circular(15)))
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
                                        height: trackHeight,
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
                                      height: trackHeight,
                                      width: trackLength,
                                    ),
                                    Positioned(
                                      left: completedStart,
                                      child: AnimatedContainer(
                                        color: Colors.green,
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.ease,
                                        height: trackHeight,
                                        width: completedWidth * animationProgress,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.ease,
                                        color: Colors.red,
                                        height: trackHeight,
                                        width: (maximumWidth * animationProgress),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /*
                              Positioned(
                                left: targetStart - 4 + targetWidth * animationProgress,
                                child: AnimatedContainer(duration: Duration(seconds: 1), child: GSTrackCategoryMarker(0.0, height + 2)),
                              ),*/
                              Positioned(
                                left: -2,
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 250),
                                      curve: Curves.ease,
                                      color: Colors.transparent,
                                      height: trackHeight,
                                      width: animationProgress * targetWidth,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: trackHeight,
                                          width: 2,
                                          color: Colors.white.withOpacity(.5),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
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
                                      color: Colors.black.withOpacity(.05),
                                      height: 0,
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
