import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/CountdownProvider.dart';

import '../Exercise/AddExercise.dart';
import '../Exercise/ExerciseList.dart';

class WorkoutScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutScreen({@required this.workout});

  void fillCountdownProvider(context) {
    Provider.of<CountdownProvider>(context).exercises = workout.exercises;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          workout.name,
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
                            "${workout.exercises.length} Exercises",
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${workout.repetitions} Repetition",
                              style: Theme.of(context).textTheme.headline),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "${workout.breakDuration.inSeconds} Seconds Break",
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
                    exercises: workout.exercises,
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
          fillCountdownProvider(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExercise(workout: workout),
            ),
          );
        },
      ),
    );
  }
}
