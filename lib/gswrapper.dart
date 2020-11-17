import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/pages/courses/courses_page.dart';
import 'package:provider/provider.dart';
import 'login/sign_in.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 1000)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (user != null) {
              return CoursesPage();
            }
            return SignInScreen();
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
