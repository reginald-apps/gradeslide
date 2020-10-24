import 'package:flutter/material.dart';

class GSTrackCourseMarker extends StatelessWidget {
  double startOffset;
  double trackHeight;
  Color color;

  GSTrackCourseMarker(this.startOffset, this.trackHeight, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 10,
          height: 3,
          color: color,
        ),
        Container(
          width: 3,
          height: trackHeight,
          color: color,
        ),
        Container(
          width: 10,
          height: 3,
          color: color,
        ),
      ],
    );
  }
}
