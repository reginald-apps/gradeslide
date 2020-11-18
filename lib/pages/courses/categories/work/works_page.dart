import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard_gstrack.dart';
import 'package:gradeslide/pages/courses/categories/work/works_gscard.dart';
import 'package:gradeslide/pages/courses/courses_gscard_gstrack.dart';
import 'package:provider/provider.dart';

class WorksPage extends StatefulWidget {
  final Course course;
  final Category category;
  final List<Category> categoriesInCourse;
  final int navigateToIndex;

  WorksPage(this.course, this.category, this.categoriesInCourse, this.navigateToIndex);

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
          return Scaffold(
              appBar: AppBar(
                toolbarHeight: 200.0,
                title: Text(
                  widget.course.title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.sort),
                    onPressed: () {
                      setState(() {
                        isSortMode = !isSortMode;
                        _controller.reset();
                        _controller.forward();
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                worksInCourse.length.toString(),
                                textScaleFactor: 2,
                              ),
                              Text(
                                " ${widget.category.name}",
                                textScaleFactor: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GSTrackCategory(widget.category),
                      ),
                    ],
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
                          Container(
                            //color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                            color: isDark ? Colors.white10 : Colors.white,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 25.0, top: 5.0, bottom: 5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Complete",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey.withOpacity(.5)),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "Title",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey.withOpacity(.5)),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "Score",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey.withOpacity(.5)),
                                  )),
                                ],
                              ),
                            ),
                          ),
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
                                      return GSCardWork(work.key, work.value, isEditingMode);
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ));
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
