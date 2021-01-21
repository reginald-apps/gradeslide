import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/work/works_gscard_gstrack.dart';
import 'package:gradeslide/pages/courses/categories/work/works_page.dart';

class ShowWorks extends StatefulWidget {
  final List<Work> works;
  final Course course;
  final Category category;
  final List<Category> categoriesInCourse;
  final Function(Category) onExpanded;

  const ShowWorks({this.course, this.category, this.works, this.categoriesInCourse, this.onExpanded});

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
        if (widget.category.isShowingMore) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          DatabaseService db = DatabaseService();
          db.updateCategoryIsShowMore(widget.category.documentId, !widget.category.isShowingMore);
          widget.onExpanded(widget.category);
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
      },
      child: LayoutBuilder(builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            color: Colors.grey.withOpacity(.15),
            child: Column(
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      widget.category.isShowingMore ? "Show ${widget.works.length} ${widget.category.name}" : "Show Less",
                      textScaleFactor: .85,
                      style: TextStyle(color: Colors.grey.withOpacity(.50)),
                      textAlign: TextAlign.center,
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
                      Container(
                        height: 30,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Complete",
                                    style: TextStyle(color: Colors.grey.withOpacity(.50)),
                                    textAlign: TextAlign.left,
                                    textScaleFactor: .75,
                                  ),
                                )),
                            Expanded(
                                flex: 8,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Title",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey.withOpacity(.50)),
                                    textAlign: TextAlign.left,
                                    textScaleFactor: .75,
                                  ),
                                )),
                            Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    "Points",
                                    textAlign: TextAlign.center,
                                    textScaleFactor: .75,
                                    style: TextStyle(color: Colors.grey.withOpacity(.50)),
                                  ),
                                )),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 0.0),
                                child: Text("Score",
                                    textScaleFactor: .75,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.grey.withOpacity(.50),
                                    )),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(),
                                ))
                          ],
                        ),
                      ),
                      Column(
                        children: widget.works
                            .asMap()
                            .entries
                            .map((e) => InkWell(
                                  onTap: () {
                                    //  Navigator.of(context)
                                    //      .push(MaterialPageRoute(builder: (context) => WorksPage(widget.course, widget.category, widget.categoriesInCourse, e.key)));
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Opacity(
                                        opacity: .85,
                                        child: Container(
                                          height: 35,
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
                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                                                      textAlign: TextAlign.left,
                                                    )),
                                                Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      "{${e.value.pointsEarned}/${e.value.pointsMax}}",
                                                      style: TextStyle(color: Colors.white),
                                                      textAlign: TextAlign.center,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      "${((e.value.pointsEarned / e.value.pointsMax) * 100).truncate()}%",
                                                      style: TextStyle(color: Colors.white),
                                                      textAlign: TextAlign.end,
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
                                      ),
                                      Container(color: e.value.completed ? Colors.green[400] : Colors.orange[200], child: GSTrackWork(e.value, false, true)),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
