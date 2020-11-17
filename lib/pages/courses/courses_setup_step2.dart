import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard_fake.dart';

class CourseSetup2 extends StatefulWidget {
  CourseSetup2();

  @override
  _CourseSetup2State createState() => _CourseSetup2State();
}

class _CourseSetup2State extends State<CourseSetup2> {
  List<String> categories;
  List<String> suggestions;
  TextEditingController _controller;

  @override
  void initState() {
    categories = [];
    suggestions = ["Assignments", "Exams", "Final Exam", "Homework", "Labs", "Quizzes"];
    _controller = TextEditingController();

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
        appBar: AppBar(
          title: Column(
            children: [
              Text("Course Setup"),
              Text("(Step 2 of 3)", textScaleFactor: .75, textAlign: TextAlign.center),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3, color: Colors.white.withOpacity(.75))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 3, color: Colors.blue.withOpacity(1))),
                              labelText: "Category Name",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: Colors.blue),
                              hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
                              hintText: "Ex. Exams"),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      MaterialButton(
                        shape: CircleBorder(),
                        child: Icon(Icons.add),
                        onPressed: () {},
                        color: Colors.green,
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Categories",
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 2,
                        ),
                      )),
                  SizedBox(height: 10),
                  Expanded(
                    child: categories != null
                        ? ReorderableListView(
                            onReorder: (int oldIndex, int newIndex) {},
                            children: categories.where((e) => (suggestions.contains(e))).map((e) => buildCategories(e)).toList())
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Suggestions",
                                style: TextStyle(color: Colors.white),
                                textScaleFactor: 2,
                              ),
                              Text(
                                "You have no categories",
                                style: TextStyle(color: Colors.white.withOpacity(.5)),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.25,
                              ),
                              Text(
                                "Tap + or use a suggestion",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.5,
                              ),
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Suggestions",
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 2,
                        ),
                      )),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: suggestions.where((e) => (!categories.contains(e))).map((e) => buildSuggestion(e)).toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildSuggestion(String title) {
    return Row(
      children: [
        Expanded(child: Center(child: Text(title, textScaleFactor: 1.75))),
        MaterialButton(
            shape: CircleBorder(),
            child: Icon(Icons.add),
            color: Colors.green,
            onPressed: () {
              setState(() {
                categories.add(title);
              });
            }),
        Divider(
          thickness: 2,
        )
      ],
    );
  }

  Widget buildCategories(String title) {
    return ListTile(
      key: ValueKey(title),
      tileColor: Colors.white,
      title: Text(title),
      trailing: Icon(Icons.menu),
    );
  }
}
