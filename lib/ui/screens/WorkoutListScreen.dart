import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';
import 'package:workout_timer/ui/screens/HomeScreen.dart';

import '../workout/AddWorkout.dart';
import '../workout/WorkoutList.dart';


class WorkoutListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Consumer<WorkoutListProvider>(
              builder: (context, workoutList, child) {
                return WorkoutList(
                  workouts: workoutList.workouts,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddWorkout(),
            ),
          );
        },
      ),
    );
  }
}
