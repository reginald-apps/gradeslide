import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GSTrackCourseTitle extends StatefulWidget {
  final double grade;
  final double gradePointsEarned;
  final double gradePointsMax;
  final double target;
  final double targetPointsEarned;
  final double targetPointsMax;
  final double max;
  final double maxPointsEarned;
  final double maxPointsMax;
  final bool isOverview;

  GSTrackCourseTitle({
    this.grade,
    this.gradePointsEarned,
    this.gradePointsMax,
    this.target,
    this.targetPointsEarned,
    this.targetPointsMax,
    this.max,
    this.maxPointsEarned,
    this.maxPointsMax,
    this.isOverview = false,
  });

  @override
  _GSTrackCourseTitleState createState() => _GSTrackCourseTitleState();
}

class _GSTrackCourseTitleState extends State<GSTrackCourseTitle> with SingleTickerProviderStateMixin {
  AnimationController _animation;
  Animation<double> _scaleAnimation;
  bool _gradeChanging;
  bool _targetChanging;
  bool _maxChanging;

  @override
  void initState() {
    _animation = AnimationController(vsync: this, duration: Duration(milliseconds: 250))
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.completed:
            _animation.reverse();
            break;
          default:
            break;
        }
      });
    _scaleAnimation = CurvedAnimation(parent: _animation, curve: Curves.ease, reverseCurve: Curves.fastOutSlowIn);
    _gradeChanging = false;
    _targetChanging = false;
    _maxChanging = false;
    super.initState();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isOverview = widget.isOverview;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildTitle(
                      "Current:", Colors.green, widget.grade, widget.gradePointsEarned, widget.gradePointsMax, TextAlign.start, _scaleAnimation, _gradeChanging)),
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: _buildTitle(
                      "Goal:", Colors.amber, widget.target, widget.targetPointsEarned, widget.targetPointsMax, TextAlign.center, _scaleAnimation, _targetChanging)),
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: _buildTitle("Max:", Colors.red, widget.max, widget.maxPointsEarned, widget.maxPointsMax, TextAlign.end, _scaleAnimation, _maxChanging)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitle(String title, Color titleColor, double value, double pointsEarned, double pointsMax, TextAlign alignment, Animation animation, bool changing) {
    return Transform.scale(
      scale: changing ? (_scaleAnimation.value / 8) + 1.0 : 1,
      child: Container(
        child: Column(
          children: [
            RichText(
              textAlign: alignment,
              text: TextSpan(
                  text: '$title',
                  style: TextStyle(
                    color: titleColor,
                    fontFamily: "Montserrat-Bold",
                    fontSize: widget.isOverview ? 10 : 18,
                    shadows: [Shadow(color: titleColor, blurRadius: changing ? _scaleAnimation.value * 3 : 2)],
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: '\n${(value * 100).truncate()}%',
                        style: TextStyle(
                          color: titleColor,
                          fontFamily: "Montserrat-Bold",
                          fontSize: widget.isOverview ? 10 : 18,
                          shadows: [Shadow(color: titleColor, blurRadius: changing ? _scaleAnimation.value * 3 : 2)],
                        )),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(GSTrackCourseTitle oldWidget) {
    if (mounted) {
      if (widget.grade != oldWidget.grade && widget.max != oldWidget.max) {
        _gradeChanging = true;
        _targetChanging = false;
        _maxChanging = true;
        setState(() {
          _animation.forward();
        });
      } else if (widget.grade != oldWidget.grade) {
        _gradeChanging = true;
        _targetChanging = false;
        _maxChanging = false;
        setState(() {
          _animation.forward();
        });
      } else if (widget.target != oldWidget.target) {
        _gradeChanging = false;
        _targetChanging = true;
        _maxChanging = false;
        setState(() {
          _animation.forward();
        });
      } else if (widget.max != oldWidget.max) {
        _gradeChanging = false;
        _targetChanging = false;
        _maxChanging = true;
        setState(() {
          _animation.forward();
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }
}
