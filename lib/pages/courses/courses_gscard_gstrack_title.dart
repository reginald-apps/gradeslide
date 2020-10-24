import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GSTrackCourseTitle extends StatefulWidget {
  final double grade;
  final double target;
  final double max;

  GSTrackCourseTitle({this.grade, this.target, this.max});

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
    _animation = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
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
    return AnimatedBuilder(
      key: ValueKey("Title123"),
      animation: _animation,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTitle("Grade:", Colors.green, widget.grade, TextAlign.start, _scaleAnimation, _gradeChanging),
            _buildTitle("Target:", Colors.amber, widget.target, TextAlign.center, _scaleAnimation, _targetChanging),
            _buildTitle("Max:", Colors.red, widget.max, TextAlign.end, _scaleAnimation, _maxChanging),
          ],
        );
      },
    );
  }

  Widget _buildTitle(String title, Color titleColor, double value, TextAlign alignment, Animation animation, bool changing) {
    return Transform.scale(
      scale: changing ? (_scaleAnimation.value / 8) + 1.0 : 1,
      child: Text(
        "$title\n${(value * 100).truncate()}%",
        style: TextStyle(color: titleColor, shadows: [Shadow(color: titleColor, blurRadius: changing ? _scaleAnimation.value * 3 : 2)], fontSize: 18),
        textAlign: alignment,
        //textScaleFactor: 1.25,
      ),
    );
  }

  @override
  void didUpdateWidget(GSTrackCourseTitle oldWidget) {
    if (mounted) {
      if (widget.grade != oldWidget.grade || widget.max != oldWidget.max) {
        _gradeChanging = true;
        _targetChanging = true;
        _maxChanging = true;
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
      }
    }
    super.didUpdateWidget(oldWidget);
  }
}
