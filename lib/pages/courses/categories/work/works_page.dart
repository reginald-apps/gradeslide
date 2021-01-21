import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard_gstrack.dart';
import 'package:gradeslide/pages/courses/categories/work/works_gscard.dart';
import 'package:provider/provider.dart';

class WorksPage extends StatefulWidget {
  final Course course;
  final Category category;
  final List<Category> categoriesInCourse;
  final int navigateToIndex;
  final Function onPickerChanged;
  final Work highlightWork;
  final int workKey;

  WorksPage(this.course, this.category, this.categoriesInCourse, this.navigateToIndex, this.onPickerChanged, this.highlightWork, this.workKey);

  @override
  _WorksPageState createState() => _WorksPageState();
}

class _WorksPageState extends State<WorksPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  TapGestureRecognizer editingMode;
  bool isEditingMode;
  bool isSortMode;
  ScrollController _trackingScrollController;

  @override
  void initState() {
    super.initState();
    isEditingMode = false;
    isSortMode = false;
    editingMode = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          isEditingMode = !isEditingMode;
        });
      };
    _trackingScrollController = ScrollController();
    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this)..forward();
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
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    List<Work> worksInCourse = [];
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return StreamBuilder(
        stream: db.streamWorks(widget.category.documentId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            worksInCourse = snapshot.data;
            _sort(worksInCourse);
            for (int i = 0; i < worksInCourse.length; i++) {
              db.setWorkIndex(worksInCourse[i].documentId, i);
            }
          }
          return widget.highlightWork == null
              ? Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 0,
                    title: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        widget.category.name,
                        style: Theme.of(context).textTheme.bodyText1,
                        textScaleFactor: 1.25,
                      ),
                    ),
                    leading: Container(),
                    bottom: PreferredSize(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GSTrackCategory(widget.category, true, (val) => {}, false),
                      ),
                      preferredSize: Size(0, 0),
                    ),
                  ),
                  body: Container(
                    child: isSortMode
                        ? ReorderableListView(
                            children: worksInCourse.map((e) {
                              return ListTile(
                                key: ValueKey(e.documentId),
                                trailing: Icon(
                                  Icons.menu,
                                  size: 35,
                                ),
                                leading: Text(
                                  "#${e.index}",
                                  textScaleFactor: 1.50,
                                ),
                                tileColor: Colors.white,
                                title: Text(
                                  e.name,
                                  textScaleFactor: 1.50,
                                ),
                              );
                            }).toList(),
                            onReorder: (m, n) {
                              print("Moving Index: $m to $n");
                              if (m > n) {
                                //Moving Bottom to Top
                                db.setWorkIndex(worksInCourse[m].documentId, n);
                                db.setWorkIndex(worksInCourse[n].documentId, m);
                              } else {
                                //Moving Top to Bottom
                                db.setWorkIndex(worksInCourse[m].documentId, n);
                              }
                            })
                        : Column(
                            children: <Widget>[
                              Divider(
                                height: 0,
                                color: Colors.white.withOpacity(.65),
                                thickness: .5,
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: ListView(
                                        controller: _trackingScrollController,
                                        children: worksInCourse.asMap().entries.map((work) {
                                          return GSCardWork(
                                              id: work.key,
                                              work: work.value,
                                              works: worksInCourse,
                                              categoryWeight: widget.category.weight,
                                              isEditingMode: isEditingMode,
                                              onPickerChanged: widget.onPickerChanged);
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ))
              : ListView(
                  controller: _trackingScrollController,
                  physics: NeverScrollableScrollPhysics(),
                  children: worksInCourse.sublist(widget.workKey).asMap().entries.map((work) {
                    return GSCardWork(
                        id: work.key,
                        work: work.value,
                        works: worksInCourse,
                        categoryWeight: widget.category.weight,
                        isEditingMode: isEditingMode,
                        onPickerChanged: widget.onPickerChanged);
                  }).toList());
        });
  }

  void _sort(List<Work> works) {
    return works.sort((a, b) {
      if (a.index < b.index) {
        return -1;
      } else if (a.index > b.index) {
        return 1;
      } else {
        return 0;
      }
    });
  }
}
