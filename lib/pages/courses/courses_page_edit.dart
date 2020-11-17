import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:provider/provider.dart';

class CourseEditPage extends StatefulWidget {
  final Course course;

  CourseEditPage(this.course);

  @override
  _CourseEditPageState createState() => _CourseEditPageState();
}

class _CourseEditPageState extends State<CourseEditPage> {
  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.course.title}"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                //Perform saving here!
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Center(
            child: RaisedButton(
              onPressed: () {
                db.deleteCourse(widget.course.documentId);
                Navigator.pop(context);
              },
              color: Colors.red,
              child: Icon(Icons.delete_forever),
            ),
          )
        ],
      ),
    );
  }
}
