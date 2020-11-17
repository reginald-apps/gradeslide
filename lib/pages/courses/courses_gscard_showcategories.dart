import 'package:flutter/material.dart';
import 'package:gradeslide/logic/database_service.dart';

class CourseCardShowCategories extends StatefulWidget {
  @override
  _CourseCardShowCategoriesState createState() => _CourseCardShowCategoriesState();
}

class _CourseCardShowCategoriesState extends State<CourseCardShowCategories> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static final Animatable<double> _sizeTween = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );
  Animation<double> _sizeAnimation;
  bool showMore = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    final CurvedAnimation curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _sizeAnimation = _sizeTween.animate(curve);
    _controller.addListener(() {
      setState(() {});
    });
    switch (_sizeAnimation.status) {
      case AnimationStatus.completed:
        _controller.reverse();
        break;
      case AnimationStatus.dismissed:
        if (showMore) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
        break;
      case AnimationStatus.reverse:
      case AnimationStatus.forward:
        break;
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _toggleExpand() {
    setState(() {
      showMore = !showMore;
      switch (_sizeAnimation.status) {
        case AnimationStatus.completed:
          _controller.reverse();
          break;
        case AnimationStatus.dismissed:
          _controller.forward();
          break;
        case AnimationStatus.reverse:
        case AnimationStatus.forward:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _toggleExpand();
            print('?');
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12.5)),
          child: Container(
            color: Colors.grey.withOpacity(.15),
            child: Column(
              children: [
                Container(
                  height: 25,
                  child: InkWell(
                    child: Center(
                      child: Text(
                        showMore ? "Show Categories" : "Show Less",
                        textScaleFactor: .85,
                        style: TextStyle(color: Colors.grey.withOpacity(.50)),
                      ),
                    ),
                  ),
                ),
                SizeTransition(
                  sizeFactor: _sizeAnimation,
                  child: Column(
                    children: [
                      Divider(
                        thickness: 1,
                        height: 5,
                        endIndent: 5,
                        indent: 5,
                      ),
                      Container(height: 30),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
