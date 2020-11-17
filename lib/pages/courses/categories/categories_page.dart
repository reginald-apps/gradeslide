import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard.dart';
import 'package:gradeslide/pages/courses/courses_gscard_gstrack.dart';
import 'package:provider/provider.dart';

import '../../../gssettings.dart';

class CategoriesPage extends StatefulWidget {
  final Course course;

  CategoriesPage(this.course);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  bool isEditingMode;
  bool isSortMode;
  int weightRemaining;
  bool weighingDone;
  TapGestureRecognizer editingMode;
  TrackingScrollController _trackingScrollController;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
    weightRemaining = 0;
    weighingDone = false;
    isEditingMode = false;
    isSortMode = false;
    editingMode = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          isEditingMode = !isEditingMode;
        });
      };
    super.initState();
    _trackingScrollController = TrackingScrollController();
    _trackingScrollController.addListener(changeSelector);
  }

  changeSelector() {
    var scrollValue = _trackingScrollController.offset;
    //print(scrollValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    List<Category> categoriesInCourse = [];
    double totalWeight = 0;
    return FutureBuilder(
      future: db.getCourseSorts(widget.course.documentId),
      builder: (context, mainSortSnapshot) {
        return StreamBuilder<List<Category>>(
            stream: db.streamCategories(widget.course.documentId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                categoriesInCourse = snapshot.data;
                _sort(categoriesInCourse);
              }
              totalWeight = 0;
              categoriesInCourse.forEach((element) {
                totalWeight += element.weight;
              });
              if (weightRemaining == 0 && totalWeight > 0) {
                weightRemaining = ((1 - totalWeight) * 100).round().toInt();
              }
              return Scaffold(
                  // drawer: Drawer(child: SettingsPage()),
                  appBar: AppBar(
                    toolbarHeight: 200.0,
                    title: GestureDetector(
                      child: Text(
                        widget.course.title ?? "?",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor, decoration: TextDecoration.underline),
                      ),
                      onTap: () {
                        showCourseCreation(context);
                      },
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.sort),
                        onPressed: () {
                          setState(() {
                            isSortMode = !isSortMode;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            isEditingMode = !isEditingMode;
                          });
                        },
                      ),
                    ],
                    bottom: PreferredSize(
                      child: Column(
                        children: <Widget>[
                          GSTrackCourse(widget.course),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Center(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Rubric",
                                      style: TextStyle(color: Colors.white),
                                      textScaleFactor: 3,
                                    ),
                                  ),
                                  totalWeight < 1 && categoriesInCourse.isNotEmpty && weightRemaining > 0
                                      ? Container(
                                          height: 50,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              "Weight must be a total of 1",
                                              style: TextStyle(color: Colors.red, fontSize: 12),
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      preferredSize: Size(0, 0),
                    ),
                  ),
                  body: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            color: Theme.of(context).cardColor,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Title",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey.withOpacity(.5)),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "Worth",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey.withOpacity(.5)),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "Quantity",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey.withOpacity(.5)),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                          ),
                          Expanded(
                            child: Scrollbar(
                              controller: _trackingScrollController,
                              child: ListView.builder(
                                controller: _trackingScrollController,
                                itemCount: categoriesInCourse.length,
                                itemBuilder: (context, i) {
                                  return GSCardCategory(widget.course, categoriesInCourse[i], widget.course.documentId, categoriesInCourse, isEditingMode, (value) {
                                    setState(() {
                                      weightRemaining = value;
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            });
      },
    );
  }

  void _sort(List<Category> categories) {
    return categories.sort((a, b) {
      if (a.index < b.index) {
        return -1;
      } else if (a.index > b.index) {
        return 1;
      } else {
        if (a.weight < b.weight) {
          return 1;
        } else if (a.weight > b.weight) {
          return -1;
        } else {
          if (!a.name.toLowerCase().compareTo(b.name.toLowerCase().toString()).isNegative) {
            return 1;
          } else if (a.name.toLowerCase().compareTo(b.name.toLowerCase().toString()).isNegative) {
            return -1;
          } else {
            return 0;
          }
        }
      }
    });
  }

  void _sortByIndex(List<Category> categories) {
    return categories.sort((a, b) {
      int categoryA = a.index;
      int categoryB = b.index;
      if (categoryA < categoryB) {
        return -1;
      } else if (categoryA > categoryB) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  void _sortByWeight(List<Category> categories) {
    return categories.sort((a, b) {
      double categoryA = a.weight;
      double categoryB = b.weight;
      if (categoryA < categoryB) {
        return 1;
      } else if (categoryA > categoryB) {
        return -1;
      } else {
        if (!a.name.toLowerCase().compareTo(b.name.toLowerCase().toString()).isNegative) {
          return 1;
        } else if (a.name.toLowerCase().compareTo(b.name.toLowerCase().toString()).isNegative) {
          return -1;
        } else {
          return 0;
        }
      }
    });
  }

  void _sortByName(List<Category> categories) {
    return categories.sort((a, b) {
      if (!a.name.toLowerCase().compareTo(b.name.toLowerCase().toString()).isNegative) {
        return 1;
      } else if (a.name.toLowerCase().compareTo(b.name.toLowerCase().toString()).isNegative) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  void showCourseCreation(BuildContext context) {
    showModalBottomSheet(
        context: context,
        elevation: 5.0,
        builder: (context) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(15))),
                  height: 10,
                  width: 75,
                ),
                //buildCourseCreateButton(MdiIcons.script, "Manual Setup"),
                //buildCourseCreateButton(MdiIcons.earthArrowRight, "Transfer via Course Code"),
              ],
            ),
          );
        });
  }
}
