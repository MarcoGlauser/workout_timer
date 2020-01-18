import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Fireworks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FireworksState();
}

class _FireworksState extends State<Fireworks> {
  final List<Widget> fireworkWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: fireworkWidgets +
            [
              Center(
                child: Text(
                  'Well Done!',
                  style: Theme.of(context).textTheme.headline,
                ),
              )
            ],
        fit: StackFit.expand);
  }

  @override
  void initState() {
    super.initState();
    for (int x in Iterable<int>.generate(12)) {
      fireworkWidgets.add(buildFirework());
    }
  }

  Widget buildFirework() {
    Random rng = Random();
    FlareControls _controls = FireworksController();
    FlareActor actor = FlareActor(
      "assets/firework.flr",
      alignment: Alignment.center,
      fit: BoxFit.contain,
      controller: _controls,
      animation: "idle",
      callback: (name) => _controls.onCompleted(name),
    );
    return Positioned(
      left: rng.nextInt(400).toDouble() - 100,
      top: rng.nextInt(600).toDouble() - 100,
      width: 200,
      height: 120,
      child: Container(child: actor),
    );
  }
}

class FireworksController extends FlareControls {
  final Random rng = Random();

  @override
  void onCompleted(String name) {
    super.onCompleted(name);
    Future.delayed(
        Duration(milliseconds: rng.nextInt(5000)), () => play("Play"));
  }
}
