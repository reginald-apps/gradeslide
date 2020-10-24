import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';

class GSTrackWork extends StatefulWidget {
  final Work work;
  final bool isEditingMode;

  const GSTrackWork(this.work, this.isEditingMode);

  @override
  _GSTrackWorkState createState() => _GSTrackWorkState();
}

class _GSTrackWorkState extends State<GSTrackWork> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _animation;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
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
    var isDark = Theme.of(context).brightness == Brightness.dark;
    var work = widget.work;
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 10, right: 25.0),
      child: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        return AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget child) {
            return Container(
              decoration:
                  BoxDecoration(border: Border.all(width: 3, color: work.completed ? Colors.green : Colors.orange), borderRadius: BorderRadius.all(Radius.circular(15))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.ease,
                      child: FlareActor(
                        "flares/progbar.flr",
                        fit: BoxFit.cover,
                        animation: "Progress",
                      ),
                      height: 10,
                      width: width,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        curve: Curves.ease,
                        color: work.completed ? Colors.red : Colors.orange.withOpacity(.30),
                        height: 10,
                        width: width,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        curve: Curves.ease,
                        color: work.completed
                            ? isDark
                                ? Colors.green[600]
                                : Colors.green
                            : isDark
                                ? Colors.orange[600]
                                : Colors.orange,
                        height: 10,
                        width: width * ((work.pointsEarned / work.pointsMax)) * _animation.value,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
