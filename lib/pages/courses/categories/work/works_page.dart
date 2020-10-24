import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard_gstrack.dart';
import 'package:gradeslide/pages/courses/categories/work/works_gscard.dart';
import 'package:gradeslide/pages/courses/courses_gscard_gstrack.dart';

class WorksPage extends StatefulWidget {
  final Course course;
  final Category category;
  final List<Category> categoriesInCourse;
  final int navigateToIndex;

  WorksPage(this.course, this.category, this.categoriesInCourse, this.navigateToIndex);

  @override
  _WorksPageState createState() => _WorksPageState();
}

class _WorksPageState extends State<WorksPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TapGestureRecognizer editingMode;
  bool isEditingMode;

  TrackingScrollController _trackingScrollController;

  @override
  void initState() {
    super.initState();
    isEditingMode = false;
    editingMode = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          isEditingMode = !isEditingMode;
        });
      };
    _trackingScrollController = TrackingScrollController();
    _trackingScrollController.addListener(changeSelector);
  }

  changeSelector() {
    var scrollValue = _trackingScrollController.offset;
    print(scrollValue);
  }

  @override
  Widget build(BuildContext context) {
    var db = DatabaseService();
    List<Work> worksInCourse = [];

    return StreamBuilder(
        stream: db.streamWorks(widget.category.documentId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            worksInCourse = snapshot.data;
          }
          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                toolbarHeight: 200.0,
                title: Text(
                  widget.course.title,
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
                child: isEditingMode
                    ? ReorderableListView(
                        children: worksInCourse.map((e) {
                          return Container(
                            key: ValueKey(e.documentId),
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.name,
                                  textScaleFactor: 1.50,
                                ),
                                Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 35,
                                )
                              ],
                            ),
                          );
                        }).toList(),
                        onReorder: (m, n) {})
                    : Column(
                        children: <Widget>[
                          Divider(
                            color: Colors.white.withOpacity(.75),
                            height: 0,
                            thickness: 1,
                          ),
                          Container(
                            color: Colors.green[400],
                            //color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 25.0, top: 5.0, bottom: 5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Complete",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white.withOpacity(.5)),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "Title",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white.withOpacity(.5)),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "Score",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white.withOpacity(.5)),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 0,
                            color: Colors.white.withOpacity(.5),
                            thickness: 1,
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
}
