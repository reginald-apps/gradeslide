import 'package:flutter/material.dart';
import 'package:gradeslide/pages/courses/courses_setup_step2.dart';

class CourseSetup1 extends StatefulWidget {
  CourseSetup1();

  @override
  _CourseSetup1State createState() => _CourseSetup1State();
}

class _CourseSetup1State extends State<CourseSetup1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text("Course Setup"),
              Text("(Step 1 of 3)", textScaleFactor: .75, textAlign: TextAlign.center),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3, color: Colors.white.withOpacity(.75))),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 3, color: Colors.blue.withOpacity(1))),
                    labelText: "Course Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(color: Colors.blue),
                    hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
                    hintText: "Ex. Chemistry"),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: MaterialButton(
                    child: Container(
                        height: 60,
                        child: Center(
                            child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.blue),
                        ))),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CourseSetup2()));
                    },
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
