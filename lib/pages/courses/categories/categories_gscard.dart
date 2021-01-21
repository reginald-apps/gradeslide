import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard_gstrack.dart';
import 'package:gradeslide/pages/courses/categories/work/works_gsstory.dart';
import 'package:gradeslide/pages/courses/categories/work/works_page.dart';
import 'package:provider/provider.dart';

class GSCardCategory extends StatefulWidget {
  final Course course;
  final String courseKey;
  final List<Category> categoriesInCourse;
  final Category category;
  final Function() onPickerChanged;
  final bool isEditingMode;

  const GSCardCategory(this.course, this.category, this.courseKey, this.categoriesInCourse, this.isEditingMode, this.onPickerChanged);

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
    DatabaseService db = Provider.of<DatabaseService>(context);
    List<Work> works = [];
    return MaterialButton(
      padding: EdgeInsets.zero,
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          SafeArea(
            child: StreamBuilder<List<Work>>(
              stream: db.streamWorks(widget.category.documentId),
              builder: (_, worksSnapshot) {
                if (worksSnapshot.hasData) {
                  works = worksSnapshot.data;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Text(widget.category.name, style: Theme.of(context).textTheme.bodyText1, textScaleFactor: 1.50), //iPhone 1.5,
                                  Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.grey.withOpacity(0),
                                      indent: 5,
                                      endIndent: 0,
                                    ),
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${(widget.category.weight * 100).truncate()}%",
                                  style: Theme.of(context).textTheme.bodyText1, textScaleFactor: 1.50, //iPhone 1.5
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey.withOpacity(0),
                                    indent: 0,
                                    endIndent: 10,
                                  ),
                                ),
                                Row(
                                  children: [
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
                                    Opacity(opacity: .35, child: Icon(Icons.arrow_forward_ios_rounded)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GSTrackCategory(widget.category, true, (val) => {}, false),
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<List<Work>>(
                        stream: db.streamWorks(widget.category.documentId),
                        builder: (context, snapshot) {
                          List<Work> workStories = [];
                          if (snapshot.hasData) {
                            workStories = snapshot.data;
                          }
                          return Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 5,
                            children: workStories.map((work) => WorkStory(work)).toList(),
                          );
                        }),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
      onPressed: () {
        Scaffold.of(context).showBottomSheet(
          (context) => Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0),
            child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                child: WorksPage(widget.course, widget.category, widget.categoriesInCourse, 0, widget.onPickerChanged, null, 0)),
          ),
          elevation: 10,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        );
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => WorksPage(widget.course, widget.category, widget.categoriesInCourse, 0)));
      },
    );
  }
}
