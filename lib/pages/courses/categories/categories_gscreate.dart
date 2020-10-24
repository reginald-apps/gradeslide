import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';

class GSCategoryCreate extends StatefulWidget {
  GSCategoryCreate(course, category, List<Category> categoriesInCourse);

  @override
  _GSCategoryCreateState createState() => _GSCategoryCreateState();
}

class _GSCategoryCreateState extends State<GSCategoryCreate> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
