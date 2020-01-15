import 'package:flutter/material.dart';
import 'package:workout_timer/ui/Fireworks.dart';
import 'package:workout_timer/ui/screens/LoginRequired.dart';

class WorkoutFinished extends StatelessWidget {
  static const route = '/workout/finished';

  @override
  Widget build(BuildContext context) {
    return LoginRequired(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Fireworks(),
          ),
        ),
        floatingActionButton: Container(
          width: 200,
          height: 100,
          margin: EdgeInsets.only(bottom: 100),
          child: RawMaterialButton(
              shape: StadiumBorder(),
              fillColor: Theme.of(context).accentColor,
              child: Text(
                "Finish",
                style: Theme.of(context).textTheme.headline,
              ),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
