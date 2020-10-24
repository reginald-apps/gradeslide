import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';

class GSPickerWork extends StatefulWidget {
  final Work work;

  const GSPickerWork({this.work});

  @override
  _GSPickerWorkState createState() => _GSPickerWorkState();
}

class _GSPickerWorkState extends State<GSPickerWork> {
  int selected;

  @override
  void initState() {
    selected = widget.work.pointsEarned;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var db = DatabaseService();
    return DecoratedBox(
      child: RotatedBox(
        child: Container(
          width: 72,
          child: Center(
            child: NotificationListener(
              onNotification: (ScrollEndNotification scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  //Will only update when user has stopped scrolling in picker.
                  print(selected);

                  return true;
                } else {
                  return false;
                }
              },
              child: CupertinoPicker(
                backgroundColor: widget.work.completed ? Colors.green[600] : Colors.orange[600],
                useMagnifier: true,
                itemExtent: 100,
                looping: true,
                scrollController: FixedExtentScrollController(initialItem: widget.work.pointsEarned),
                onSelectedItemChanged: (value) {
                  setState(() {});
                  selected = value;
                  db.updateWorkEarned(widget.work.documentId, value);
                },
                diameterRatio: 100,
                children: List<Widget>.generate(widget.work.pointsMax + 1, (index) {
                  var isSelected = index == selected;
                  return Center(
                      child: Center(
                    child: RotatedBox(
                      child: Container(
                          height: 75,
                          child: Center(
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Align(
                                        child: Container(
                                          color: Colors.orange[100],
                                          width: 1,
                                          height: 10,
                                        ),
                                        alignment: Alignment.topCenter,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: isSelected ? 12.0 : 0.0),
                                        child: Text(
                                          isSelected ? "${index}" : "$index",
                                          textScaleFactor: isSelected ? 1.50 : 1.00,
                                          style: TextStyle(color: Colors.white.withOpacity(isSelected ? 0.90 : 0.50), fontFamily: "Montserrat-Bold"),
                                        ),
                                      ),
                                      Align(
                                        child: Container(
                                          color: Colors.orange[100],
                                          width: 1,
                                          height: 10,
                                        ),
                                        alignment: Alignment.bottomCenter,
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      "${(index == selected ? "points" : "")}",
                                      textScaleFactor: .45,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(isSelected ? 0.75 : 0.30), fontWeight: FontWeight.bold, fontFamily: "Montserrat-Bold"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      quarterTurns: 1,
                    ),
                  ));
                }),
              ),
            ),
          ),
        ),
        quarterTurns: 3,
      ),
      decoration: BoxDecoration(),
    );
  }
}
