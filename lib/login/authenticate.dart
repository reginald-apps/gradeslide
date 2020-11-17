import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradeslide/login/register.dart';
import 'package:gradeslide/login/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return SignInScreen(toggleView: toggleView);
  }
}
