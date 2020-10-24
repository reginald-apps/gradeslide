import 'package:flutter/material.dart';
import 'package:gradeslide/logic/course_data.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard_gsslide_tickmark.dart';

class GSConstants {
  static final List<double> defaultScale = [0.94, 0.90, 0.87, 0.84, 0.80, 0.77, 0.74, 0.70, 0.65, 0.0];
  static final List<String> defaultScaleLetters = ["A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D", "F"];
  static final List<Color> defaultColorIds = [
    Colors.redAccent,
    Colors.pink,
    Colors.amber[600],
    Colors.blue,
    Colors.indigoAccent,
    Colors.brown,
  ];
  static final List<String> defaultColorNames = ["Red", "Pink", "Orange", "Blue", "Indigo", "Brown"];
  static final List<String> defaultFonts = ["Fredoka", "Arial", "Roboto", "Fira", "Teko", "Lobster"];

  static final defaultCourse = new Course(
      prefix: "NA",
      id: 101,
      title: "Untitled Default",
      credits: 3,
      categoryList: [Category(name: "CATEGORY 1", weight: 1.0, grades: [])],
      scale: GSConstants.defaultScale,
      totalPoints: 100);
  static final List<Course> sampleCourse = [
    Course(prefix: "GS", id: 101, title: "Sample Course", credits: 2, totalPoints: 100, categoryList: [
      Category(name: "EXAMS", weight: 0.30, grades: [
        Work(name: "EXAM 1", pointsMax: 20, pointsEarned: 17, completed: true),
        Work(name: "EXAM 2", pointsMax: 20, pointsEarned: 18, completed: false),
      ]),
      Category(name: "QUIZZES", weight: 0.50, grades: [
        Work(name: "QUIZ 1", pointsMax: 5, pointsEarned: 4, completed: true),
        Work(name: "QUIZ 2", pointsMax: 5, pointsEarned: 5, completed: false),
        Work(name: "QUIZ 2", pointsMax: 5, pointsEarned: 5, completed: false),
      ]),
      Category(name: "HOMEWORK", weight: 0.20, grades: [
        Work(name: "HW 1", pointsMax: 10, pointsEarned: 10, completed: true),
        Work(name: "HW 2", pointsMax: 10, pointsEarned: 9, completed: false),
      ]),
    ], scale: [
      0.94,
      0.90,
      0.87,
      0.84,
      0.80,
      0.77,
      0.74,
      0.70,
      0.65,
      0.0
    ])
  ];

  static final Color defaultColor = Colors.blue;
  static final ThemeData defaultTheme = ThemeData(
      primarySwatch: defaultColor,
      primaryColor: defaultColor,
      accentColor: defaultColor,
      brightness: Brightness.light,
      fontFamily: "Montserrat-Bold",
      snackBarTheme: SnackBarThemeData(backgroundColor: defaultColor),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: defaultColor, modalBackgroundColor: Colors.transparent),
      canvasColor: Color.fromARGB(255, 51, 104, 170),
      toggleableActiveColor: Colors.green[200],
      unselectedWidgetColor: Colors.white70,
      cursorColor: defaultColor,
      sliderTheme: SliderThemeData(tickMarkShape: GSTickMark(tickMarkRadius: 0.5), trackHeight: 2.5, valueIndicatorColor: defaultColor),
      tabBarTheme: TabBarTheme(
          labelColor: defaultColor,
          indicator: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)), color: Colors.white),
          unselectedLabelColor: Colors.white),
      scaffoldBackgroundColor: Color.fromARGB(255, 51, 104, 170),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: defaultColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(foregroundColor: Colors.white),
      textTheme: TextTheme(
          subtitle1: TextStyle(color: Colors.white),
          headline6: TextStyle(color: defaultColor, shadows: [Shadow(color: defaultColor, blurRadius: 0)]),
          bodyText2: TextStyle(color: defaultColor, shadows: [Shadow(color: defaultColor, blurRadius: 0)]),
          bodyText1: TextStyle(color: defaultColor, shadows: [Shadow(color: defaultColor, blurRadius: 1)])),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(unselectedItemColor: Colors.white));
}
