import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:workout_timer/services/CountdownProvider.dart';
import 'package:workout_timer/core/AudioController.dart';

class CountdownTimer extends StatefulWidget {
  final String title;
  final Duration duration;
  final String next;

  CountdownTimer({Key key, this.title, this.duration, this.next,}) : super(key: key);

  @override
  _CountdownTimerState createState() {
    return _CountdownTimerState();
  }
}

class _CountdownTimerState extends State<CountdownTimer> with TickerProviderStateMixin {
  AnimationController _controller;
  Selector selector;

  @override
  void initState() {
    super.initState();
    final ac = AudioController(widget.duration.inSeconds);
    ac.addSignal(3, 'beep.mp3');
    ac.addSignal(2, 'beep.mp3');
    ac.addSignal(1, 'beep.mp3');
    ac.addSignal(0, 'long_beep.mp3');

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1.0,
    );
    _controller.addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.dismissed) {
        Provider.of<CountdownProvider>(context, listen: false).exerciseFinished();
      }
    });
    _controller.addListener((){
      ac.checkSoundToPlay(_controller.value);
    });
    _controller.reverse(from: 1.0);
  }

  String get timeString {
    Duration duration = _controller.duration * _controller.value;
    return '${duration.inMinutes}:${(duration.inMilliseconds/1000 % 60).ceil().toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
            Container(),
            Container(
              child: GestureDetector(
                onTap: () {
                  if (_controller.isAnimating) {
                    _controller.stop();
                  } else {
                    _controller.reverse(
                        from: _controller.value == 0.0
                            ? 1.0
                            : _controller.value
                    );
                  }
                },
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      height: 300,
                      width: 300,
                      child: CustomPaint(
                        painter: DrawCircle(
                          timeAnimation: _controller,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.title,
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      AnimatedBuilder(
                          animation: _controller,
                          builder: (BuildContext context, Widget child) {
                            return Text(
                              timeString,
                              style: Theme.of(context).textTheme.display3,
                            );
                          }),
                    ]),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text('Next:', style: Theme.of(context).textTheme.headline),
                  Text(widget.next, style: Theme.of(context).textTheme.display1),
                ],
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DrawCircle extends CustomPainter {
  final Animation<double> timeAnimation;
  final Color backgroundColor, color;

  DrawCircle({this.timeAnimation,  this.backgroundColor, this.color}) : super(repaint:timeAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill;

    paint.color = backgroundColor;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);

    paint.color = Colors.grey[300];
    paint.style = PaintingStyle.stroke;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, 1.0* 2 * math.pi, false, paint);
    paint.color = color;
    double progress = (1.0 - timeAnimation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, progress, false, paint);
  }

  @override
  bool shouldRepaint(DrawCircle old) {
    return timeAnimation.value != old.timeAnimation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}