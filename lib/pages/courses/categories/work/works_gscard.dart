import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/logic/gsmaths.dart';
import 'package:gradeslide/pages/courses/categories/work/works_gscard_gspicker.dart';
import 'package:gradeslide/pages/courses/categories/work/works_gscard_gstrack.dart';
import 'package:provider/provider.dart';

class GSCardWork extends StatefulWidget {
  final int id;
  final Work work;
  final List<Work> works;
  final double categoryWeight;
  final bool isEditingMode;

  GSCardWork(this.id, this.work, this.works, this.categoryWeight, this.isEditingMode);

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
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: CircleAvatar(
                            radius: 50,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${((widget.work.pointsEarned / widget.work.pointsMax) * 100).toInt()}%",
                                    textScaleFactor: 1.5,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: titleColor),
                                  ),
                                ],
                              ),
                            ),
                            backgroundColor: work.completed ? Colors.green : Colors.orangeAccent,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, top: 0.0),
                          child: Column(
                            children: [
                              SizedBox(height: 15),
                              Text(
                                "${work.name}",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.20,
                                style: TextStyle(decoration: TextDecoration.underline, color: titleColor, fontWeight: FontWeight.w900),
                              ),
                              Text(
                                "Adjusted Weight: ${(GradeSlideMaths.getWorth(widget.works, widget.work) * widget.categoryWeight).toStringAsPrecision(2)}",
                                style: TextStyle(color: titleColor.withOpacity(.65)),
                                textAlign: TextAlign.center,
                                textScaleFactor: .85,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          child: Stack(
                            children: [
                              Card(
                                child: Container(
                                  height: 40,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 40,
                                      ),
                                    ],
                                  ),
                                ),
                                color: work.completed ? Colors.transparent : Colors.orange,
                                margin: EdgeInsets.only(left: 10.5, top: 12.5),
                                elevation: 0,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 9.0, left: 7),
                                  child: Transform.scale(
                                    scale: 1.5,
                                    child: Checkbox(
                                      value: work.completed,
                                      onChanged: (bool) {
                                        db.setWorkCompleted(widget.work.documentId, bool);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GSTrackWork(widget.work, widget.isEditingMode, false),
              ],
            ),
          ),
          SizedBox(
            height: 10,
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
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              color: work.completed ? Colors.green[600] : Colors.orange[600],
              curve: work.completed ? Curves.fastOutSlowIn : Curves.easeOut,
              height: work.completed ? 0 : 75,
              child: GSPickerWork(
                work: widget.work,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
