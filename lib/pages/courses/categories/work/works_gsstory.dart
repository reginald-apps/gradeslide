import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';

class WorkStory extends StatelessWidget {
  final Work work;

  const WorkStory(this.work);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              work.duedate == null
                  ? "NO DUE DATE"
                  : work.completed
                      ? " "
                      : "2 DAYS LEFT",
              textScaleFactor: .60,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.withOpacity(.75)),
            ),
          ),
          SizedBox(
            height: 7.5,
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: work.completed ? Colors.green[500] : Colors.orange[400],
                child: Padding(
                  padding: EdgeInsets.only(top: (work.pointsMax - work.pointsEarned > 0) ? 20.0 : 25.0),
                  child: Column(
                    children: [
                      Text(
                        "${((work.pointsEarned / work.pointsMax) * 100).truncate()}%",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "${work.pointsEarned}/${work.pointsMax}",
                        textScaleFactor: .65,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: work.completed ? Colors.white.withOpacity(.5) : Colors.white.withOpacity(.5)),
                      ),
                      work.pointsMax - work.pointsEarned > 0
                          ? Text(
                              "-${work.pointsMax - work.pointsEarned} points",
                              textScaleFactor: .5,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: work.completed ? Colors.red.withOpacity(.75) : Colors.white.withOpacity(.5)),
                            )
                          : Text(""),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                width: 80,
                child: CustomPaint(
                  painter: CircleProgress(work.pointsEarned / work.pointsMax, work.completed),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 7.5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              "${work.name}",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: .60,
              textAlign: TextAlign.center,
              style: TextStyle(color: work.completed ? Colors.green[500] : Colors.orange[400]),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleProgress extends CustomPainter {
  double currentProgress;
  bool isCompleted;

  CircleProgress(this.currentProgress, this.isCompleted);

  @override
  void paint(Canvas canvas, Size size) {
    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 3
      ..color = isCompleted ? Colors.green.withOpacity(.25) : Colors.orangeAccent.withOpacity(.25)
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 3
      ..color = isCompleted ? Colors.green : Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) + 4;

    canvas.drawCircle(center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
