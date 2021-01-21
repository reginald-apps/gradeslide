import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/gsmaths.dart';

class GSTrackCategoryTitle extends StatelessWidget {
  final List<Work> works;

  const GSTrackCategoryTitle(this.works);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  "Grade:",
                  style: TextStyle(color: Colors.green),
                  textScaleFactor: .65,
                ),
                Text(
                  "${(GradeSlideMaths.getCategoryCompletedGrade(works, false)[0] * 100).round()}%",
                  style: TextStyle(color: Colors.green),
                  textScaleFactor: .65,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Target:",
                  style: TextStyle(color: Colors.amber),
                  textScaleFactor: .65,
                ),
                Text(
                  "${(GradeSlideMaths.getCategoryTargetGrade(works)[0] * 100).round()}%",
                  style: TextStyle(color: Colors.orange),
                  textScaleFactor: .65,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  "Maximum:",
                  style: TextStyle(color: Colors.red),
                  textScaleFactor: .65,
                ),
                Text(
                  "${(GradeSlideMaths.getCategoryMaximumTargetGrade(works)[0] * 100).round()}%",
                  style: TextStyle(color: Colors.red),
                  textScaleFactor: .65,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ),
        ],
      ),
    );
  }
}
