import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/course_gscard_workstory_highlight.dart';
import 'package:gradeslide/pages/courses/courses_gscard_gstrack.dart';
import 'package:provider/provider.dart';

class GradeSlidePage extends StatefulWidget {
  final Key key;
  final Course course;
  final bool isEditMode;

  const GradeSlidePage(this.key, this.course, this.isEditMode) : super(key: key);

  @override
  _GradeSlidePageState createState() => _GradeSlidePageState();
}

class _GradeSlidePageState extends State<GradeSlidePage> with TickerProviderStateMixin {
  AnimationController _startUpController;
  AnimationController _startSizeController;
  CurvedAnimation _startUpAnimation;
  Animation<double> _sizeAnimation;
  Animation<Offset> _offsetAnimation;
  bool isShowMore = false;
  Work selectedWork;
  Category selectedCategory;
  bool _isSortMode;
  bool _isEditMode;
  @override
  void initState() {
    _isSortMode = false;
    _isEditMode = widget.isEditMode;
    _startUpController = AnimationController(duration: Duration(milliseconds: 1250), vsync: this);
    _startSizeController = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _startUpAnimation = CurvedAnimation(parent: _startUpController, curve: Curves.fastOutSlowIn);
    _sizeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _startSizeController,
      curve: Curves.easeOutBack,
    ));

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _startUpController,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    _startUpController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _startUpController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Rubric"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              setState(() {
                _isSortMode = !_isSortMode;
              });
            },
            splashRadius: 15,
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
            ),
            splashRadius: 15,
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: _isSortMode ? 0.0 : 8.0, right: _isSortMode ? 0.0 : 8.0, bottom: 12),
        child: _isSortMode
            ? StreamBuilder<List<Category>>(
                stream: db.streamCategories(widget.course.documentId),
                builder: (context, categoriesSnapshot) {
                  return ReorderableListView(
                      children: categoriesSnapshot.hasData
                          ? categoriesSnapshot.data
                              .map((category) => ListTile(
                                    key: ValueKey(category.documentId),
                                    title: Text(
                                      category.name,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    trailing: Icon(Icons.menu),
                                    subtitle: Text(
                                      "Weight: ${category.weight.toString()}",
                                      textScaleFactor: .75,
                                    ),
                                    tileColor: Theme.of(context).cardColor,
                                  ))
                              .toList()
                          : [],
                      onReorder: (i, e) {});
                })
            : InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                onTap: () {},
                child: FadeTransition(
                  opacity: _startUpAnimation,
                  child: Card(
                    elevation: 5,
                    color: Theme.of(context).cardColor.withOpacity(.90),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                widget.course.title,
                                textScaleFactor: 1.75,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: GSTrackCourse(course: widget.course, animatedStart: true, isOverview: false),
                              ),
                              Expanded(
                                  child: CourseCardRubricOverview(
                                course: widget.course,
                                onPickerChanged: () {
                                  setState(() {});
                                },
                                isOverview: false,
                              )),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(side: BorderSide(width: 5, color: Colors.black12), borderRadius: BorderRadius.all(Radius.circular(7.5))),
                  ),
                ),
              ),
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
