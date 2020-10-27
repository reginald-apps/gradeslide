import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradeslide/gswrapper.dart';
import 'package:gradeslide/logic/gsconstants.dart';
import 'package:gradeslide/login/auth_service.dart';
import 'package:gradeslide/pages/courses/categories/categories_gscard_gsslide_tickmark.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Firestore.instance.settings(persistenceEnabled: true);
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().user,
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: darkMode(),
        theme: GSConstants.defaultTheme,
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData darkMode() {
    Color favColor = Colors.amber;
    return ThemeData(
      primaryColor: favColor,
      accentColor: favColor,
      brightness: Brightness.dark,
      fontFamily: "Montserrat-Bold",
      snackBarTheme: SnackBarThemeData(backgroundColor: favColor),
      toggleableActiveColor: Colors.green[200],
      sliderTheme: SliderThemeData(tickMarkShape: GSTickMark(tickMarkRadius: 0.5), trackHeight: 2.5),
      tabBarTheme: TabBarTheme(
          labelColor: favColor,
          indicator: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)), color: Colors.white10),
          unselectedLabelColor: Colors.grey),
      appBarTheme: AppBarTheme(
          color: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.grey),
          textTheme: TextTheme(headline6: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white))),
      buttonTheme: ButtonThemeData(
        buttonColor: favColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(foregroundColor: Colors.white),
      textTheme: TextTheme(
          //headline6: TextStyle(color: favColor),
          bodyText2: TextStyle(color: favColor),
          bodyText1: TextStyle(color: favColor)),
    );
  }
}
