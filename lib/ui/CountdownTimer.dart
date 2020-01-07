import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:workout_timer/provider/CountdownProvider.dart';

class CountdownTimer extends StatefulWidget {
  final String title;
  final Duration duration;
  final String next;
  BuildContext _context;

  CountdownTimer({Key key, this.title, this.duration, this.next,  context}) : super(key: key){
    _context = context;

  }

  @override
  _CountdownTimerState createState() {
    return _CountdownTimerState(_context);
  }
}

class _CountdownTimerState extends State<CountdownTimer> with TickerProviderStateMixin {
  AnimationController _controller;
  BuildContext _context;
  AudioCache audioPlayer = AudioCache(fixedPlayer: AudioPlayer(mode: PlayerMode.LOW_LATENCY));
  bool threeSeconds = false;
  bool twoSeconds = false;
  bool oneSecond = false;
  bool noSecond = false;

  _CountdownTimerState(context) : super(){
    _context = context;
  }
  Selector selector;

  @override
  void initState() {
    super.initState();
    audioPlayer.loadAll(['beep.mp3', 'long_beep.mp3']);
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1.0,
    );
    _controller.addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.dismissed) {
        Provider.of<CountdownProvider>(_context).exerciseFinished();
      }
    });
    _controller.addListener((){
      playSound(_controller.duration, _controller.value);
    });
    _controller.reverse(from: 1.0);
  }

  void playSound(Duration duration, double value){
    Duration progress = duration * value;
    int seconds = progress.inSeconds;
    if(!threeSeconds && seconds == 3){
       threeSeconds = true;
       Future.delayed(Duration(seconds: 1), () => audioPlayer.play('beep.mp3'));
    }
    if(!twoSeconds && seconds == 2){
      twoSeconds = true;
      Future.delayed(Duration(seconds: 1), () => audioPlayer.play('beep.mp3'));
    }
    if(!oneSecond && seconds == 1){
      oneSecond = true;
      Future.delayed(Duration(seconds: 1), () => audioPlayer.play('beep.mp3'));
    }
    if(!noSecond && seconds == 0){
      noSecond = true;
      Future.delayed(Duration(seconds: 1), () => audioPlayer.play('long_beep.mp3'));
    }
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