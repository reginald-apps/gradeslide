import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gradeslide/gswrapper.dart';
import 'package:gradeslide/logic/gsconstants.dart';
import 'package:gradeslide/login/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logic/database_service.dart';

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        StreamProvider.value(value: FirebaseAuth.instance.onAuthStateChanged),
        FutureProvider.value(value: SharedPreferences.getInstance()),
        Provider.value(value: DatabaseService()),
        Provider.value(value: AuthService()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        darkTheme: GSConstants.darkMode(Colors.blue),
        theme: GSConstants.defaultTheme(Colors.blue),
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
