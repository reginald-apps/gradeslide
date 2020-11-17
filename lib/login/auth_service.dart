import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Future<AuthResult> signInAnon() async {
    AuthResult result;
    try {
      result = await _auth.signInAnonymously();
    } catch (e) {
      throw e;
    }
    return result;
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
}
