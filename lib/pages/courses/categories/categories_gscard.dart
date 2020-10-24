import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard_gstrack.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard_showwords.dart';
import 'package:gradeslide/pages/courses/categories/work/works_page.dart';

class GSCardCategory extends StatefulWidget {
  final Course course;
  final String courseKey;
  final List<Category> categoriesInCourse;
  final Category category;
  final Function(int) onSlide;
  final bool isEditingMode;

  const GSCardCategory(this.course, this.category, this.courseKey, this.categoriesInCourse, this.isEditingMode, this.onSlide);

  @override
  _GSCardCategoryState createState() => _GSCardCategoryState();
}

class _GSCardCategoryState extends State<GSCardCategory> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var db = DatabaseService();
    List<Work> works = [];
    return MaterialButton(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          SafeArea(
            child: StreamBuilder<List<Work>>(
              stream: db.streamWorks(widget.category.documentId),
              builder: (_, worksSnapshot) {
                if (worksSnapshot.hasData) {
                  works = worksSnapshot.data;
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                widget.category.name,
                                textScaleFactor: 1.50,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  children: [TextSpan(text: "${(widget.category.weight * 100).toStringAsPrecision(2)}%", style: TextStyle(fontWeight: FontWeight.w900))],
                                  style: Theme.of(context).textTheme.bodyText1),
                              textScaleFactor: 1.25,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    FutureBuilder<int>(
                                        future: db.getTotalWorks(widget.category.documentId),
                                        builder: (context, snapshot) {
                                          return Row(
                                            children: [
                                              Text(
                                                "${snapshot.data ?? 0}",
                                                textScaleFactor: 1.50, //iPhone 1.5
                                                style: Theme.of(context).textTheme.bodyText1,
                                              ),
                                            ],
                                          );
                                        }),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey.withOpacity(.5),
                                    )
                                  ],
                                ),
                                widget.isEditingMode
                                    ? GestureDetector(
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onTap: () {
                                          works.forEach((workToDelete) {
                                            db.deleteWork(workToDelete.documentId);
                                          });
                                          db.deleteCategory(widget.category.documentId);
                                        },
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                        child: GSTrackCategory(widget.category),
                      ),
                      ShowWorks(course: widget.course, category: widget.category, works: works, categoriesInCourse: widget.categoriesInCourse),

                      //GSTrackCategoryTitle(worksSnapshot.data),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          )
        ],
      ),
      onPressed: () {
        //Scaffold.of(context).showBottomSheet((context) => WorksPage(widget.course, widget.category, widget.categoriesInCourse));
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => WorksPage(widget.course, widget.category, widget.categoriesInCourse, 0)));
      },
    );
  }
}
