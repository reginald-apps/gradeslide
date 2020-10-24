import 'package:flutter/material.dart';

class GSTrackCategoryMarker extends StatelessWidget {
  double startOffset;
  double trackHeight;

  GSTrackCategoryMarker(this.startOffset, this.trackHeight);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 8,
          height: 2,
          color: Colors.orange,
        ),
        Container(
          width: 2,
          height: trackHeight,
          color: Colors.orange,
        ),
        Container(
          width: 8,
          height: 2,
          color: Colors.orange,
        ),
      ],
    );
  }
}
