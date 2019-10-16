import 'package:flutter/material.dart';
import 'package:workout_timer/ui/screens/HomeScreen.dart';

class WorkoutFinished extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Login(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              "WOOHOOOOO",
              style: Theme.of(context).textTheme.display2,
            ),
          ),
        ),
        floatingActionButton: Container(
          width: 200,
          height: 200,
          child: RawMaterialButton(
              shape: CircleBorder(),
              elevation: 0.0,
              fillColor: Theme.of(context).accentColor,
              child: Text(
                "FINISH",
                style: Theme.of(context).textTheme.display1,
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
