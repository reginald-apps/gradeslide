import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/work/works_gsstory.dart';
import 'package:provider/provider.dart';

import 'categories/categories_gscard_gstrack.dart';

class CourseCardOverviewWorks extends StatefulWidget {
  final Course course;
  final Category category;
  final List<Category> categoriesInCourse;
  final Function(Work, int, Category) onSelectedWork;
  final Function() onPickerChanged;
  final Function() onCategorySelected;
  final bool isOverview;

  const CourseCardOverviewWorks(
      {this.course, this.category, this.categoriesInCourse, this.onSelectedWork, this.onPickerChanged, this.onCategorySelected, this.isOverview = false});

  @override
  CourseCardOverviewWorksState createState() => CourseCardOverviewWorksState();
}

class CourseCardOverviewWorksState extends State<CourseCardOverviewWorks> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static final Tween<double> _sizeTween = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );
  Animation<double> _sizeAnimation;
  bool isCollapsed;

  @override
  initState() {
    super.initState();
    isCollapsed = !widget.category.isShowingMore;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    final CurvedAnimation curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _sizeAnimation = _sizeTween.animate(curve);
    _controller.addListener(() {
      setState(() {});
    });
    if (isCollapsed && !widget.isOverview) {
      _controller.forward();
    }
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  _toggleExpand(Category category, DatabaseService db) {
    setState(() {
      isCollapsed = !isCollapsed;
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
    bool isOverview = widget.isOverview;
    DatabaseService db = Provider.of<DatabaseService>(context);
    Category selectedCategory = widget.category;
    return InkWell(
      onTap: () {
        if (widget.isOverview) {
          return;
        }
        if (isCollapsed) {
          db.updateCategoryIsShowMore(selectedCategory.documentId, true);
          widget.onCategorySelected.call();
        } else {
          db.updateCategoryIsShowMore(selectedCategory.documentId, false);
        }
        _toggleExpand(selectedCategory, db);
      },
      splashColor: Colors.white.withOpacity(0.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 0.0, bottom: 0.0, right: 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            selectedCategory.name,
                            textScaleFactor: isOverview ? .5 : 1,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: .45,
                            color: Colors.grey,
                            indent: 5,
                            endIndent: 0,
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${(selectedCategory.weight * 100).truncate()}%",
                        textScaleFactor: isOverview ? .5 : 1,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Divider(
                          thickness: 0.45,
                          color: Colors.grey,
                          indent: 0,
                          endIndent: 10,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<List<Work>>(
                              stream: db.streamWorks(selectedCategory.documentId),
                              builder: (context, snapshot) {
                                int numLeft = 0;
                                if (snapshot.hasData) {
                                  for (Work work in snapshot.data) {
                                    if (work.completed) {
                                      numLeft++;
                                    }
                                  }
                                }
                                return Text(
                                  "${snapshot.hasData ? (snapshot.data.length) : 0}",
                                  textScaleFactor: isOverview ? .5 : 1,
                                );
                              }),
                        ],
                      ),
                      isOverview
                          ? Container(
                              width: 10,
                            )
                          : AnimatedContainer(
                              duration: Duration(seconds: 1),
                              child: RotatedBox(
                                quarterTurns: isCollapsed ? 1 : 0,
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.grey.withOpacity(.5),
                                  size: 25,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GSTrackCategory(selectedCategory, false, (val) {}, isOverview),
          SizeTransition(
            sizeFactor: _sizeAnimation,
            child: Center(
                child: StreamBuilder<List<Work>>(
                    stream: db.streamWorks(selectedCategory.documentId),
                    builder: (context, snapshot) {
                      List<Work> workStories = [];
                      if (snapshot.hasData) {
                        workStories = snapshot.data;
                      }
                      ScrollController cont = ScrollController();
                      return SizedBox(
                        height: 150,
                        child: Scrollbar(
                          child: ListView.builder(
                            controller: cont,
                            scrollDirection: Axis.horizontal,
                            itemCount: workStories.length,
                            itemBuilder: (BuildContext context, int index) {
                              Work work = workStories[index];
                              return Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 5.0, top: 8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      widget.onSelectedWork.call(work, index, widget.category);
                                    },
                                    child: Transform.scale(scale: 1, child: WorkStory(work))),
                              );
                            },
                          ),
                        ),
                      );
                    })),
          )
        ],
      ),
    );
  }
}
