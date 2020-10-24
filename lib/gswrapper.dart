import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/gsnavpage.dart';
import 'package:gradeslide/login/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 850)),
        builder: (context, snapshot) {
          if (user != null && snapshot.connectionState == ConnectionState.done) {
            return GradeSlideNavPage();
          }
          return Authenticate();
        });
  }
}
