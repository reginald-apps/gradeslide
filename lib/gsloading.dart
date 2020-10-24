import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingScreen extends StatefulWidget {
  final String loadingText;

  LoadingScreen(this.loadingText);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  String _loadingText;

  @override
  void initState() {
    _loadingText = widget.loadingText;
    _controller = AnimationController(duration: Duration(milliseconds: 700), vsync: this)..repeat();
    _animation = Tween<double>(begin: 0.1, end: 0.43 * 1.8).animate(CurvedAnimation(parent: _controller, curve: Cubic(0.15, 0.70, 0.70, 0.15)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context, widget) {
                return Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.015)
                            ..leftTranslate(0.0, -25.0, 10.0)
                            ..rotateZ(math.pi)
                            ..rotateX(4.25 + (_animation.value * -10.0))
                            ..translate(0.0, 0, 800),
                          alignment: Alignment.center,
                          child: Transform.scale(scale: 4.0, child: RotatedBox(quarterTurns: 2, child: Image(image: ExactAssetImage('images/pencil.png'))))),
                    ),
                    /*Align(
                       alignment: Alignment.center,
                       child: CustomPaint(
                         painter: GradeSlideBorderPainter(
                             completion: _animation.value),
                       ),
                     ),*/
                    Align(
                      alignment: Alignment.center,
                      child: Opacity(
                          opacity: (_animation.value - .1) * 1.4367953,
                          child: Transform(
                            transform: Matrix4.identity()..translate(0.0, -(_animation.value * 30), 0.0),
                            child: Text(
                              "GR  DE\nSL  DE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Fredoka",
                                  fontSize: 20.0,
                                  letterSpacing: 9 - (_animation.value * 9),
                                  fontWeight: FontWeight.lerp(FontWeight.w100, FontWeight.w800, _animation.value)),
                            ),
                          )),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Opacity(
                          opacity: (_animation.value) * .2,
                          child: Transform(
                            transform: Matrix4.identity()..translate(0.0, -(_animation.value * 30), 0.0),
                            child: Text(
                              "A\nI",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white.withOpacity((_animation.value / 0.8)),
                                  fontFamily: "Fredoka",
                                  fontSize: 20.0,
                                  letterSpacing: 9 - (_animation.value * 9),
                                  fontWeight: FontWeight.lerp(FontWeight.normal, FontWeight.w900, 0.0)),
                            ),
                          )),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Opacity(
                          opacity: (_animation.value - .1) * 1.4367953,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.015)
                              ..translate(0.0, _animation.value * 100, 0.0),
                            child: Text(
                              _loadingText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Fredoka",
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.lerp(FontWeight.w400, FontWeight.w100, (0.5 - _animation.value))),
                            ),
                          )),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(style: TextStyle(color: Colors.white), children: [
                              TextSpan(text: 'Powered by\n'),
                              TextSpan(text: 'Reggie Vision™', style: TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ))
                  ],
                );
              }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
