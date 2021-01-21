import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/work/works_gscard_gspicker.dart';
import 'package:provider/provider.dart';

class GSCardWork extends StatefulWidget {
  final int id;
  final Work work;
  final List<Work> works;
  final double categoryWeight;
  final bool isEditingMode;
  final Function onPickerChanged;

  GSCardWork({this.id, this.work, this.works, this.categoryWeight, this.isEditingMode, this.onPickerChanged});

  @override
  _GSCardWorkState createState() => _GSCardWorkState();
}

class _GSCardWorkState extends State<GSCardWork> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var work = widget.work;
    var titleColor = Colors.white;
    DatabaseService db = Provider.of<DatabaseService>(context);
    return Container(
      decoration: BoxDecoration(
          color: work.completed
              ? Colors.green[Theme.of(context).brightness == Brightness.dark ? 400 : 400]
              : Colors.amber[Theme.of(context).brightness == Brightness.dark ? 500 : 600]),
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Column(
              children: <Widget>[
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "${work.name}",
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.35,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: titleColor, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 175,
                        width: 175,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: GestureDetector(
                            onTap: () {
                              db.setWorkCompleted(widget.work.documentId, !widget.work.completed);
                              widget.onPickerChanged.call();
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: CircleAvatar(
                                    radius: 60,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 15),
                                        Text(
                                          "${work.completed ? "Your grade:" : "Your goal:"}",
                                          textScaleFactor: .5,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: titleColor.withOpacity(.5)),
                                        ),
                                        Text(
                                          "${((widget.work.pointsEarned / widget.work.pointsMax) * 100).toInt()}%",
                                          textScaleFactor: 1.95,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: titleColor),
                                        ),
                                        Text(
                                          "${work.pointsEarned}/${work.pointsMax}",
                                          style: TextStyle(color: Colors.white.withOpacity(.5)),
                                          textScaleFactor: 1,
                                        ),
                                        work.completed && work.pointsMax - work.pointsEarned > 0
                                            ? Text(
                                                "-${work.pointsMax - work.pointsEarned} points",
                                                style: TextStyle(color: Colors.red.withOpacity(.5)),
                                                textScaleFactor: .55,
                                              )
                                            : Text(
                                                "",
                                                style: TextStyle(color: Colors.red.withOpacity(.5)),
                                                textScaleFactor: .55,
                                              )
                                      ],
                                    ),
                                    backgroundColor: work.completed ? Colors.green : Colors.orange[500],
                                  ),
                                ),
                                Center(
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: CustomPaint(painter: WorkCircleProgress(work.pointsEarned / work.pointsMax, work.completed)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //GSTrackWork(widget.work, widget.isEditingMode, false),
              ],
            ),
          ),
          Opacity(
            opacity: .30,
            child: Divider(
              height: 2,
              color: Colors.grey[900],
              thickness: 1,
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  color: work.completed ? Colors.green[600] : Colors.orange[700],
                  curve: work.completed ? Curves.fastOutSlowIn : Curves.easeOut,
                  height: work.completed ? 0 : 75,
                  child: GSPickerWork(
                    work: widget.work,
                    onPickerChanged: widget.onPickerChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkCircleProgress extends CustomPainter {
  double currentProgress;
  bool isCompleted;

  WorkCircleProgress(this.currentProgress, this.isCompleted);

  @override
  void paint(Canvas canvas, Size size) {
    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 4
      ..color = isCompleted ? Colors.green.withOpacity(.25) : Colors.orangeAccent.withOpacity(.75)
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 5
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
