import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';

class WorkStory extends StatelessWidget {
  final Work work;

  const WorkStory(this.work);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Container(
        height: 110,
        width: 110,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                "${work.name}",
                textScaleFactor: .60,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(color: work.completed ? Colors.green[500] : Colors.orange[400]),
              ),
            ),
            SizedBox(
              height: 7.5,
            ),
            Stack(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: work.completed ? Colors.green[500] : Colors.orange[400],
                  child: Text(
                    "${((work.pointsEarned / work.pointsMax) * 100).truncate()}%",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 90,
                  width: 90,
                  child: CustomPaint(
                    painter: CircleProgress(.50, work.completed),
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
                work.completed
                    ? "Complete"
                    : work.duedate != null
                        ? "Time left: ${work.duedate.seconds}"
                        : "No due date set",
                textScaleFactor: .50,
                textAlign: TextAlign.center,
                style: TextStyle(color: work.completed ? Colors.green[500] : Colors.orange[400]),
              ),
            ),
          ],
        ),
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
      ..strokeWidth = 4
      ..color = isCompleted ? Colors.green.withOpacity(.20) : Colors.orangeAccent.withOpacity(.5)
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 4
      ..color = isCompleted ? Colors.grey.withOpacity(0) : Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 1.5, size.height / 1.5) - 10;

    canvas.drawCircle(center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (50 / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
