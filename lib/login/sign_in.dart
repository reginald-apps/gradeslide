import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/login/auth_service.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  final Function toggleView;

  SignInScreen({this.toggleView});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  var loadingStates;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this)..forward();
    _animation = new Tween<double>(begin: 0.5, end: 0.0).animate(new CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    loadingStates = [false, false, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    SharedPreferences prefs = Provider.of<SharedPreferences>(context);
    return Scaffold(
      body: Builder(builder: (scaffoldContext) {
        return Center(
          child: SingleChildScrollView(
            child: Center(
              child: AnimatedBuilder(
                  animation: _animation,
                  child: Container(
                    width: 350,
                    child: Column(
                      children: [
                        FadeTransition(
                          opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
                          child: Text(
                            "Sign In",
                            textScaleFactor: 3,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10),
                        FadeTransition(
                          opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                widgetizeIcon(
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0, right: 6.0),
                                      child: LitAuthIcon.appleWhite(),
                                    ),
                                    "Continue with Apple",
                                    Colors.white,
                                    Colors.black, () async {
                                  setState(() {
                                    loadingStates[0] = false;
                                    loadingStates[1] = false;
                                    loadingStates[2] = false;
                                  });
                                }, loadingStates[0]),
                                widgetizeIcon(
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 0.0, right: 6.0),
                                      child: LitAuthIcon.google(),
                                    ),
                                    "Continue with Google",
                                    Colors.red,
                                    Colors.white, () async {
                                  setState(() {
                                    loadingStates[0] = false;
                                    loadingStates[1] = false;
                                    loadingStates[2] = false;
                                  });
                                }, loadingStates[1]),
                                widgetizeIcon(null, "Continue Anonymously", Colors.white, Colors.amber, () async {
                                  try {
                                    setState(() {
                                      loadingStates[0] = false;
                                      loadingStates[1] = false;
                                      loadingStates[2] = true;
                                    });
                                    var result = await authService.signInAnon();
                                  } catch (e) {
                                    Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                        e.message,
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                  }
                                }, loadingStates[2]),
                                SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  builder: (context, child) {
                    return Transform(alignment: FractionalOffset.center, transform: perspective.scaled(1.0, 1.0, 1.0)..rotateX(3.14 * _animation.value), child: child);
                  }),
            ),
          ),
        );
      }),
    );
  }

  Widget widgetizeIcon(
    Widget icon,
    String title,
    Color textColor,
    Color color,
    VoidCallback onPressed,
    bool loading,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
              height: 80,
              color: color,
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 6,
                    ))
                  : FlatButton(
                      onPressed: onPressed,
                      splashColor: color == Colors.white ? Colors.red : Colors.white.withOpacity(.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          icon != null ? icon : Container(),
                          Text(title, style: TextStyle(color: textColor, shadows: [Shadow(color: Colors.white, blurRadius: 1)]), textScaleFactor: 1.2),
                        ],
                      ),
                    ))),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
  void didUpdateWidget(covariant SignInScreen oldWidget) {
    print('?');
    super.didUpdateWidget(oldWidget);
  }
}
