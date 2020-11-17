import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/categories_page.dart';
import 'package:gradeslide/pages/courses/courses_gscard_gstrack.dart';
import 'package:provider/provider.dart';

class GSCardCourse extends StatefulWidget {
  final Key key;
  final Course course;
  final bool isEditMode;

  const GSCardCourse(this.key, this.course, this.isEditMode) : super(key: key);

  @override
  _GSCardCourseState createState() => _GSCardCourseState();
}

class _GSCardCourseState extends State<GSCardCourse> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _sizeAnimationController;
  CurvedAnimation _animation;
  Animation<Offset> _offsetAnimation;
  bool isShowMore = false;
  static final Animatable<double> _sizeTween = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );

  Animation<double> _sizeAnimation;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _sizeAnimationController = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    final CurvedAnimation curve = CurvedAnimation(parent: _sizeAnimationController, curve: Curves.easeOutBack);
    _sizeAnimation = _sizeTween.animate(curve);
    _sizeAnimationController.addListener(() {
      setState(() {});
    });
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 10, right: 8.0),
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          onTap: () {
            //db.deleteCourse(widget.course.documentId);
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesPage(widget.course)));
          },
          child: FadeTransition(
            opacity: _animation,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Card(
                elevation: 5,
                color: Theme.of(context).cardColor.withOpacity(.90),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
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
                          child: GSTrackCourse(widget.course),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 2, color: Theme.of(context).highlightColor), borderRadius: BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StreamBuilder<List<Category>>(
                                  stream: db.streamCategories(widget.course.documentId),
                                  builder: (context, categoriesSnapshot) {
                                    return FutureBuilder(
                                        future: Future.delayed(Duration(milliseconds: 1000)),
                                        builder: (context, snapshot) {
                                          return snapshot.connectionState != ConnectionState.done
                                              ? Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Center(child: CircularProgressIndicator()),
                                                )
                                              : Column(
                                                  children: categoriesSnapshot.data
                                                      .map((e) => Row(
                                                            children: [
                                                              Text(e.name),
                                                              Expanded(
                                                                  child: Divider(
                                                                thickness: .45,
                                                                color: Colors.grey,
                                                                indent: 10,
                                                                endIndent: 10,
                                                              )),
                                                              Opacity(
                                                                opacity: .50,
                                                                child: Text(
                                                                  "worth ",
                                                                  style: Theme.of(context).textTheme.subtitle1,
                                                                  textScaleFactor: .75,
                                                                ),
                                                              ),
                                                              Text("${(e.weight * 100).truncate()}%")
                                                            ],
                                                          ))
                                                      .toList(),
                                                );
                                        });
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(side: BorderSide(width: 5, color: Colors.black12), borderRadius: BorderRadius.all(Radius.circular(7.5))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
