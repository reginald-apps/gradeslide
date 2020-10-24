import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradeslide/login/auth_service.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  final Function toggleView;

  SignInScreen({this.toggleView});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  String _username, _password;
  AnimationController _controller;
  Animation _animation;
  final AuthService _auth = AuthService();
  TapGestureRecognizer signUpRecognizer;

  @override
  void initState() {
    _username = "";
    _password = "";
    signUpRecognizer = TapGestureRecognizer()
      ..onTap = () {
        widget.toggleView();
      };
    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this)..forward();
    _animation = new Tween<double>(begin: 0.5, end: 0.0).animate(new CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static Matrix4 _pmat(num pv) {
    return new Matrix4(
      1.0,
      0.0,
      0.0,
      0.0,
      //
      0.0,
      1.0,
      0.0,
      0.0,
      //
      0.0,
      0.0,
      1.0,
      pv * 0.001,
      //
      0.0,
      0.0,
      0.0,
      1.0,
    );
  }

  Matrix4 perspective = _pmat(1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: AnimatedBuilder(
                animation: _animation,
                builder: (context, snapshot) {
                  return Transform(
                    alignment: FractionalOffset.center,
                    transform: perspective.scaled(1.0, 1.0, 1.0)..rotateX(3.14 * _animation.value),
                    child: Container(
                      width: 300,
                      height: 375,
                      child: Column(
                        children: [
                          FadeTransition(
                            opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
                            child: Text(
                              "Sign In",
                              textScaleFactor: 2,
                              style: TextStyle(color: Colors.amber),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(
                              color: Colors.amber,
                            ),
                          ),
                          FadeTransition(
                            opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    widgetizeIcon(LitAuthIcon.appleWhite(), Colors.black, 4.5),
                                    widgetizeIcon(LitAuthIcon.twitter(), Colors.white, 10),
                                    widgetizeIcon(LitAuthIcon.google(), Colors.white, 6),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "- or -",
                            style: TextStyle(color: Colors.amber),
                          ),
                          FadeTransition(
                            opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                            child: SlideTransition(
                                position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
                                child: widgetizeEmail()),
                          ),
                          FadeTransition(
                            opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                            child: SlideTransition(
                                position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
                                child: widgetizePassword()),
                          ),
                          FadeTransition(opacity: CurvedAnimation(parent: _controller, curve: Curves.ease), child: widgetizeSubmit(context)),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.15,
                            text: TextSpan(style: TextStyle(color: Colors.amber, decoration: TextDecoration.underline), children: [
                              TextSpan(
                                text: "Don't have an account? ",
                              ),
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                recognizer: signUpRecognizer,
                              )
                            ]),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget widgetizeSubmit(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: RaisedButton(
          child: Container(
            height: 60,
            child: Center(
              child: Text(
                "Sign in",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          onPressed: () async {
            FirebaseUser user = await _auth.signIn(_username, _password, context);
          },
        ),
      ),
    );
  }

  Widget widgetizeEmail() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          style: TextStyle(fontSize: 14),
          onChanged: (input) => _username = input,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            labelText: 'Email',
            border: UnderlineInputBorder(),
          ),
          autovalidate: true,
          cursorWidth: 1,
        ),
      ),
    );
  }

  Widget widgetizePassword() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          style: TextStyle(fontSize: 14),
          onChanged: (input) => _password = input,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            labelText: 'Password',
            border: UnderlineInputBorder(),
          ),
          obscureText: true,
          autovalidate: true,
          cursorWidth: 1,
        ),
      ),
    );
  }

  Widget widgetizeIcon(
    LitAuthIcon icon,
    Color color,
    double scale,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 35,
        height: 35,
        color: color,
        child: FlatButton(
            onPressed: () async {
              _auth.signInWithTwitter();
            },
            splashColor: Colors.white.withOpacity(.5),
            child: Transform.scale(scale: scale, child: icon)),
      ),
    );
  }
}
