import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard.dart';
import 'package:gradeslide/pages/courses/courses_gscard_gstrack.dart';

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
  int weightRemaining;
  bool weighingDone;
  List<bool> sorts;
  TapGestureRecognizer editingMode;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
    sorts = [true, false, false];
    weightRemaining = 0;
    weighingDone = false;
    isEditingMode = false;
    editingMode = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          isEditingMode = !isEditingMode;
        });
      };
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {
    var db = DatabaseService();
    List<Category> categoriesInCourse = [];
    Future<List<PieChartSectionData>> pieChartGradeSectionx = Future.value([]);
    List<PieChartSectionData> pieChartProgressSection = [];
    List<PieChartSectionData> pieChartMaxSection = [];
    double totalWeight = 0;
    return FutureBuilder(
      future: db.getCourseSorts(widget.course.documentId),
      builder: (context, mainSortSnapshot) {
        return StreamBuilder<List<Category>>(
            stream: db.streamCategories(widget.course.documentId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                categoriesInCourse = snapshot.data;
                if (sorts[0]) {
                  _sortByIndex(categoriesInCourse);
                } else if (sorts[1]) {
                  _sortByName(categoriesInCourse);
                } else if (sorts[2]) {
                  _sortByWeight(categoriesInCourse);
                } else {
                  _sort(categoriesInCourse);
                }
                pieChartMaxSection = setPieChartMaxSections(categoriesInCourse);
                pieChartProgressSection = setPieChartProgressSections(categoriesInCourse);
              }
              totalWeight = 0;
              categoriesInCourse.forEach((element) {
                totalWeight += element.weight;
              });
              if (weightRemaining == 0 && totalWeight > 0) {
                weightRemaining = ((1 - totalWeight) * 100).round().toInt();
              }
              return Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 200.0,
                    title: Text(
                      widget.course.title ?? "?",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: isEditingMode ? "Done" : "Edit",
                                style: TextStyle(decoration: TextDecoration.underline, fontSize: 16),
                                recognizer: editingMode,
                              ),
                            ),
                          ),
                        ),
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
                    color: Theme.of(context).cardColor,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                            child: Stack(
                              children: [
                                Container(
                                  foregroundDecoration: BoxDecoration(color: isEditingMode ? Colors.green : Colors.red, backgroundBlendMode: BlendMode.color),
                                  child: FlareActor(
                                    "flares/progbar.flr",
                                    fit: BoxFit.cover,
                                    animation: "Progress",
                                  ),
                                ),
                                Center(
                                    child: Text(
                                  "Edit mode: ${isEditingMode ? 'Enabled' : 'Disabled'}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isEditingMode ? Colors.green : Colors.red,
                                    fontFamily: "Montserrat",
                                    fontSize: 15,
                                    shadows: [
                                      Shadow(color: Colors.white, blurRadius: 5),
                                      Shadow(color: Colors.white, blurRadius: 15),
                                    ],
                                  ),
                                  textScaleFactor: .75,
                                )),
                              ],
                            ),
                            color: Colors.green,
                            height: isEditingMode ? 25 : 0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Container(
                                height: 30,
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
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                          ),
                          Expanded(
                            child: ListView.builder(
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
      int categoryA = a.index;
      int categoryB = b.index;
      if (categoryA < categoryB) {
        return -1;
      } else if (categoryA > categoryB) {
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

  List<PieChartSectionData> setPieChartMaxSections(List<Category> categoriesInCourse) {
    return categoriesInCourse
        .asMap()
        .map((i, category) {
          return MapEntry(
              i,
              PieChartSectionData(
                title: "${category.name} (${(category.weight * 100).toInt()}%)",
                value: category.weight,
                radius: 80,
                titlePositionPercentageOffset: 1.5,
                color: Colors.red,
                titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ));
        })
        .values
        .toList();
  }

  List<PieChartSectionData> setPieChartProgressSections(List<Category> categoriesInCourse) {
    return categoriesInCourse
        .asMap()
        .map((i, category) {
          return MapEntry(
              i,
              PieChartSectionData(
                title: "",
                value: category.weight,
                radius: (1 - category.weight) * 80,
                titlePositionPercentageOffset: 0.75,
                color: Colors.orangeAccent,
                titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ));
        })
        .values
        .toList();
  }
}
