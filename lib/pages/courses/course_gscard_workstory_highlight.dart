import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/work/works_gscard_gspicker.dart';
import 'package:provider/provider.dart';
import 'courses_gscard_workstories.dart';
import 'dart:math' as math;

class CourseCardRubricOverview extends StatefulWidget {
  final Course course;
  final Work work;
  final Function() onPickerChanged;
  final Function(Work) onWorkSelected;
  final bool isOverview;

  const CourseCardRubricOverview({this.course, this.work, this.onPickerChanged, this.onWorkSelected, this.isOverview = false});

  @override
  _CourseCardRubricOverviewState createState() => _CourseCardRubricOverviewState();
}

class _CourseCardRubricOverviewState extends State<CourseCardRubricOverview> {
  covariant Work _selectedWork;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                decoration: BoxDecoration(border: Border.all(width: 2, color: Theme.of(context).highlightColor), borderRadius: BorderRadius.all(Radius.circular(5))),
                child: StreamBuilder<List<Category>>(
                    stream: db.streamCategories(widget.course.documentId),
                    builder: (streamContext, categoriesSnapshot) {
                      return FutureBuilder(
                          future: Future.delayed(Duration(milliseconds: 250)),
                          builder: (context, categoriesLoading) {
                            List<Category> categoriesList = [];
                            if (categoriesSnapshot.hasData) {
                              categoriesList = categoriesSnapshot.data;
                            }
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "Title",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey.withOpacity(.5)),
                                        textScaleFactor: widget.isOverview ? .5 : 1,
                                      )),
                                      Expanded(
                                          child: Text(
                                        "Worth",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey.withOpacity(.5)),
                                        textScaleFactor: widget.isOverview ? .5 : 1,
                                      )),
                                      Expanded(
                                          child: Text(
                                        "Quantity",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey.withOpacity(.5)),
                                        textScaleFactor: widget.isOverview ? .5 : 1,
                                      )),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  height: 5,
                                ),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      ListView(
                                        children: [
                                          categoriesList.isEmpty
                                              ? Center(
                                                  child: CircularProgressIndicator(
                                                  backgroundColor: Colors.amber,
                                                ))
                                              : Column(
                                                  children: [
                                                    Column(
                                                      children: _sort(categoriesList)
                                                          .map((category) => CourseCardOverviewWorks(
                                                                course: widget.course,
                                                                category: category,
                                                                categoriesInCourse: categoriesList,
                                                                onPickerChanged: () {},
                                                                onCategorySelected: () {
                                                                  setState(() {});
                                                                },
                                                                onSelectedWork: (selectedWork, workKey, selectedCategory) {
                                                                  setState(() {
                                                                    _selectedWork = selectedWork;
                                                                  });
                                                                },
                                                                isOverview: widget.isOverview,
                                                              ))
                                                          .toList(),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                      widget.isOverview
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(3.5)),
                                                  gradient: LinearGradient(
                                                      colors: [Colors.grey[400].withOpacity(.35), Colors.grey[200].withOpacity(.5), Colors.white.withOpacity(0)],
                                                      transform: GradientRotation(-math.pi / 2))),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                                widget.isOverview
                                    ? Container()
                                    : Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                gradient: RadialGradient(colors: [Colors.white, Colors.grey], radius: 5, transform: GradientRotation(3.14))),
                                            height: 70,
                                            child: _selectedWork != null
                                                ? GSPickerWork(
                                                    work: _selectedWork,
                                                    isSmaller: true,
                                                    onPickerChanged: () {
                                                      setState(() {
                                                        widget.onPickerChanged.call();
                                                      });
                                                    })
                                                : Center(
                                                    child: Text(
                                                    "No category or work selected",
                                                    style: TextStyle(color: Colors.grey),
                                                    textScaleFactor: .75,
                                                  )),
                                          ),
                                        ],
                                      )
                              ],
                            );
                          });
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Category> _sort(List<Category> categories) {
  categories.sort((a, b) {
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
  return categories;
}
