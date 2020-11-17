import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard_gstrack.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard_showwords.dart';
import 'package:gradeslide/pages/courses/categories/work/works_page.dart';
import 'package:provider/provider.dart';

class GSCardCategoryFake extends StatefulWidget {
  final Category category;
  final bool isEditingMode;
  final Function onRemove;
  const GSCardCategoryFake(this.category, this.isEditingMode, this.onRemove);

  @override
  _GSCardCategoryFakeState createState() => _GSCardCategoryFakeState();
}

class _GSCardCategoryFakeState extends State<GSCardCategoryFake> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          MaterialButton(
                            shape: CircleBorder(),
                            child: Icon(Icons.remove),
                            color: Colors.red,
                            onPressed: widget.onRemove,
                          ),
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
                                  children: [TextSpan(text: "${(widget.category.weight * 100).truncate()}%", style: TextStyle(fontWeight: FontWeight.w900))],
                                  style: Theme.of(context).textTheme.bodyText1),
                              textScaleFactor: 1.25,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.menu,
                                      color: Colors.grey.withOpacity(.5),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // GSTrackCategoryTitle(worksSnapshot.data),
                    ],
                  ))),
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
      },
    );
  }
}
