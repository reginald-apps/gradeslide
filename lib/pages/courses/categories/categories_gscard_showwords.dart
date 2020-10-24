import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/work/works_page.dart';

class ShowWorks extends StatefulWidget {
  final List<Work> works;
  final Course course;
  final Category category;
  final List<Category> categoriesInCourse;

  const ShowWorks({this.course, this.category, this.works, this.categoriesInCourse});

  @override
  _ShowWorksState createState() => _ShowWorksState();
}

class _ShowWorksState extends State<ShowWorks> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  static final Animatable<double> _sizeTween = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );

  Animation<double> _sizeAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
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
        if (widget.category.isShowMore) {
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
      DatabaseService().updateisShowMore(widget.category.documentId, !widget.category.isShowMore);
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _toggleExpand();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          color: Colors.grey.withOpacity(.15),
          child: Column(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    widget.category.isShowMore ? "Show ${widget.works.length} ${widget.category.name}" : "Show Less",
                    textScaleFactor: .85,
                    style: TextStyle(color: Colors.grey.withOpacity(.50)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizeTransition(
                sizeFactor: _sizeAnimation,
                child: Column(
                  children: widget.works
                      .asMap()
                      .entries
                      .map((e) => InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => WorksPage(widget.course, widget.category, widget.categoriesInCourse, e.key)));
                            },
                            child: Container(
                              height: 40,
                              color: e.value.completed ? Colors.green[400] : Colors.amber[700],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Stack(
                                          children: [
                                            Icon(
                                              e.value.completed ? Icons.check : null,
                                              color: Colors.white.withOpacity(.75),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 35, top: 2),
                                              child: Text(
                                                "#${e.key + 1}",
                                                style: TextStyle(color: Colors.white),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                        flex: 8,
                                        child: Text(
                                          "${e.value.name}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.left,
                                        )),
                                    Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "${e.value.pointsEarned}/",
                                                  style: TextStyle(color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  "Points",
                                                  textScaleFactor: .5,
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "${e.value.pointsMax}",
                                                  style: TextStyle(color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          "${((e.value.pointsEarned / e.value.pointsMax) * 100).truncate()}%",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 30,
                                            child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
