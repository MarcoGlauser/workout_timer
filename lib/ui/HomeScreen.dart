import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';

import 'AddWorkout.dart';
import 'WorkoutList.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Consumer<WorkoutListProvider>(
              builder: (context, workoutList, child) {
                return WorkoutList(
                  workouts: workoutList.workouts,
                );
              },
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Add more"),
                    ),
                    onPressed: () {
                      print(Provider.of<FirebaseUser>(context));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => AddWorkout(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
