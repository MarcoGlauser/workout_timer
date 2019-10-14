import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';

import '../Exercise/AddExercise.dart';
import '../Exercise/ExerciseList.dart';

class WorkoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutListProvider>(
      builder: (context, workoutListProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              workoutListProvider.activeWorkout.name,
              style: Theme.of(context).textTheme.display1,
            ),
            elevation: 0,
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${workoutListProvider.activeWorkout.exercises.length} Exercises",
                                style: Theme.of(context).textTheme.headline,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${workoutListProvider.activeWorkout.repetitions} Repetition",
                                  style: Theme.of(context).textTheme.headline),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${workoutListProvider.activeWorkout.breakDuration.inSeconds} Seconds Break",
                                  style: Theme.of(context).textTheme.headline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ExerciseList(
                        exercises: workoutListProvider.activeWorkout.exercises,
                      ),
                    ],
                  ),
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
                  builder: (context) => AddExercise(workout: workoutListProvider.activeWorkout),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
