import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradeslide/login/auth_service.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggleView;

  RegisterScreen({this.toggleView});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  AnimationController _controller;
  Animation _animation;
  String _username, _password;
  TapGestureRecognizer signInRecognizer;

  @override
  void initState() {
    _username = "";
    _password = "";
    signInRecognizer = TapGestureRecognizer()
      ..onTap = () {
        widget.toggleView();
      };
    _controller = AnimationController(duration: Duration(milliseconds: 750), vsync: this)..forward();
    _animation = new Tween<double>(begin: -0.5, end: 0.0).animate(new CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
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
                      height: 325,
                      child: Column(
                        children: [
                          Text(
                            "Sign Up",
                            textScaleFactor: 2,
                            style: TextStyle(color: Colors.amber),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(
                              color: Colors.amber,
                            ),
                          ),
                          widgetizeEmail(),
                          widgetizePassword(),
                          widgetizeSubmit(context),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.15,
                            text: TextSpan(style: TextStyle(color: Colors.amber, decoration: TextDecoration.underline), children: [
                              TextSpan(
                                text: "Existing User? ",
                              ),
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                recognizer: signInRecognizer,
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
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          onPressed: () {
            _auth.signUp(_username, _password, context);
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
          decoration: InputDecoration(prefixIcon: Icon(Icons.email), labelText: 'Email', border: UnderlineInputBorder(), hoverColor: Colors.white),
          cursorWidth: 1,
          autovalidateMode: AutovalidateMode.always,
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
          autovalidateMode: AutovalidateMode.always,
          cursorWidth: 1,
        ),
      ),
    );
  }

  Widget widgetizeIcon(LitAuthIcon icon, Color color, double scale) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 35,
        height: 35,
        color: color,
        child: FlatButton(
            onPressed: () {
              print('?');
            },
            splashColor: Colors.white.withOpacity(.5),
            child: Transform.scale(scale: scale, child: icon)),
      ),
    );
  }
}
