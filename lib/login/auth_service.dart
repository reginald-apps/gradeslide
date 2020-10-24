import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:gradeslide/login/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final TwitterLogin _twitterLogin = TwitterLogin(
    consumerKey: "OyOLKF2YT4OpwEbs1oCohpzQp",
    consumerSecret: "sy1iuqV620sCJ06EfDedmA6TOlJ9quRErOMr0R3YrmvoH6E4Kd",
  );

  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Future<User> signInAnon() async {
    FirebaseUser user;
    try {
      AuthResult result = await _auth.signInAnonymously();
      user = result.user;
    } catch (e) {
      print(e);
    }
    return _userFromFirebase(user);
  }

  Future<FirebaseUser> signIn(String email, String password, BuildContext context) async {
    FirebaseUser user;
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      user = result.user;
    } catch (e) {
      if (e is PlatformException) {
        Flushbar(
          title: e.code,
          message: e.message,
          icon: Icon(
            Icons.warning_amber_rounded,
            size: 28,
            color: Colors.yellow,
          ),
          leftBarIndicatorColor: Colors.yellow,
          duration: Duration(seconds: 2),
        )..show(context);
      }
    }
    return user;
  }

  Future<FirebaseUser> signUp(String email, String password, BuildContext context) async {
    FirebaseUser user;
    print(email);

    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      user = result.user;
    } catch (e) {
      if (e is PlatformException) {
        Flushbar(
          title: e.code,
          message: e.message,
          icon: Icon(
            Icons.warning_amber_rounded,
            size: 28,
            color: Colors.yellow,
          ),
          leftBarIndicatorColor: Colors.yellow,
          duration: Duration(seconds: 2),
        )..show(context);
      }
    }
    return user;
  }

  Future<User> signInWithTwitter() async {
    final TwitterLoginResult result = await _twitterLogin.authorize();
    try {
      switch (result.status) {
        case TwitterLoginStatus.loggedIn:
          print(result.session.userId);
          break;
        case TwitterLoginStatus.cancelledByUser:
          break;
        case TwitterLoginStatus.error:
          print(result.errorMessage);
          break;
      }
    } catch (e) {
      print(e);
    }
    return User(uid: result.session.userId);
  }
}
