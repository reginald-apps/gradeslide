import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:provider/provider.dart';

class GSPickerWork extends StatefulWidget {
  final Work work;
  final bool isSmaller;
  final Function() onPickerChanged;

  const GSPickerWork({this.work, this.isSmaller = false, this.onPickerChanged});

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
    DatabaseService db = Provider.of<DatabaseService>(context);
    return DecoratedBox(
      child: RotatedBox(
        child: Container(
          width: widget.isSmaller ? 28 : 72,
          child: Center(
            child: NotificationListener(
              onNotification: (ScrollEndNotification scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  //Will only update when user has stopped scrolling in picker.
                  return true;
                } else {
                  return false;
                }
              },
              child: Stack(
                children: [
                  CupertinoPicker(
                    backgroundColor: widget.work.completed ? Colors.green[600] : Colors.orange[600],
                    //useMagnifier: true,
                    itemExtent: 100,

                    looping: true,
                    scrollController: FixedExtentScrollController(initialItem: widget.work.pointsEarned),
                    onSelectedItemChanged: (value) {
                      setState(() {
                        widget.onPickerChanged.call();
                        db.updateWorkEarned(widget.work.documentId, value);
                      });
                      selected = value;
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
                                              height: widget.isSmaller ? 5 : 10,
                                            ),
                                            alignment: Alignment.topCenter,
                                          ),
                                          Text(
                                            isSelected ? "${index}" : "$index",
                                            textScaleFactor: isSelected
                                                ? widget.isSmaller
                                                    ? 1
                                                    : 1.30
                                                : widget.isSmaller
                                                    ? 1.00 / 1.5
                                                    : .85,
                                            style: TextStyle(color: Colors.white.withOpacity(isSelected ? 0.90 : 0.35), fontFamily: "Montserrat-Bold"),
                                          ),
                                          Align(
                                            child: Container(
                                              color: Colors.orange[100],
                                              width: 1,
                                              height: widget.isSmaller ? 4 : 10,
                                            ),
                                            alignment: Alignment.bottomCenter,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: widget.isSmaller ? 6.0 : 14.0),
                                        child: Text(
                                          "${(index == selected ? "points" : "")}",
                                          textScaleFactor: widget.isSmaller ? 0 : .40,
                                          style: TextStyle(
                                              color: Colors.white.withOpacity(isSelected ? 0.75 : 0.20), fontWeight: FontWeight.bold, fontFamily: "Montserrat-Bold"),
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
                ],
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
