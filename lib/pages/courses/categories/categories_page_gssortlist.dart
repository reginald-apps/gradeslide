import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';

class GSListCategory extends StatefulWidget {
  @override
  _GSListCategoryState createState() => _GSListCategoryState();

  final Course course;
  final List<Category> categoriesInCourse;
  final Function onReorder;

  GSListCategory({
    @required this.categoriesInCourse,
    @required this.course,
    this.onReorder,
  });
}

class _GSListCategoryState extends State<GSListCategory> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _animation;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var db = DatabaseService();
    var categoriesInCourse = widget.categoriesInCourse;
    return ReorderableListView(
      children: categoriesInCourse
          .map((e) => AnimatedContainer(
                duration: Duration(seconds: 1),
                key: ValueKey(e),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(2 + e.index / categoriesInCourse.length, 0.0),
                    end: Offset.zero,
                  ).animate(_animation),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0 * e.index / categoriesInCourse.length,
                      end: 1.0,
                    ).animate(_animation),
                    child: (Card(
                        elevation: 1,
                        child: ListTile(
                          title: Text(e.name),
                          subtitle: Text("Weight: ${(e.weight * 100).truncate()}%"),
                          trailing: Icon(Icons.menu),
                        ))),
                  ),
                ),
              ))
          .toList(),
      onReorder: (int oldIndex, int newIndex) {
        widget.onReorder.call();
        setState(() {
          _controller.reset();
          _controller.forward();
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
        });
        final Category movingCategory = categoriesInCourse.removeAt(oldIndex);
        categoriesInCourse.insert(newIndex, movingCategory);
        db.setCategoryIndices(categoriesInCourse);
      },
    );
  }
}
