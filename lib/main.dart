import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradeslide/logic/gsconstants.dart';
import 'package:gradeslide/login/auth_service.dart';
import 'package:gradeslide/pages/courses/courses_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logic/database_service.dart';
import 'login/sign_in.dart';

void main() {
  runApp(MyApp());
  Firestore.instance.settings(persistenceEnabled: true);
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        StreamProvider.value(value: FirebaseAuth.instance.onAuthStateChanged),
        FutureProvider.value(value: SharedPreferences.getInstance()),
        Provider.value(value: DatabaseService()),
        Provider.value(value: AuthService()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: GSConstants.darkMode(Colors.blue),
        theme: GSConstants.defaultTheme(Colors.blue),
        home: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 1000)),
            builder: (context, snapshot) {
              FirebaseUser user = Provider.of<FirebaseUser>(context);
              if (snapshot.connectionState == ConnectionState.done) {
                if (user != null) {
                  return CoursesPage();
                }
                return SignInScreen();
              } else {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
            }),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
