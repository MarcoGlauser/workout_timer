import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/DatabaseService.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';
import 'package:workout_timer/ui/screens/LoginRequired.dart';
import 'package:workout_timer/ui/workout/WorkoutOptions.dart';

import '../AddSubtract.dart';
import '../exercise/AddExercise.dart';
import '../exercise/ExerciseList.dart';

class WorkoutScreenArguments {
  final Workout workout;

  WorkoutScreenArguments(this.workout);
}

class WorkoutScreen extends StatelessWidget {
  static const route = '/workout/edit';

  @override
  Widget build(BuildContext context) {
    final WorkoutScreenArguments screenArguments = ModalRoute.of(context).settings.arguments;
    final Workout workout = screenArguments.workout;

    return LoginRequired(
      child: Consumer<WorkoutListProvider>(
        builder: (context, workoutListProvider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                workout.name,
              ),
              actions: <Widget>[
                WorkoutOptions(workout: workout),
              ],
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              AddSubtract(
                                child: Text(
                                    "${workout.repetitions} Repetition",
                                    style: Theme.of(context).textTheme.title),
                                onAdd: () {
                                  workout.increaseRepetitions();
                                  GetIt.instance
                                      .get<DatabaseService>()
                                      .saveWorkout(workout);
                                },
                                onSubtract: () {
                                  workout.decreaseRepetitions();
                                  GetIt.instance
                                      .get<DatabaseService>()
                                      .saveWorkout(workout);
                                },
                              ),
                              AddSubtract(
                                child: Text(
                                    "${workout.breakDuration.inMinutes.toString().padLeft(2, '0')}:${(workout.breakDuration.inSeconds % 60).toString().padLeft(2, '0')}  Break",
                                    style: Theme.of(context).textTheme.title),
                                onAdd: () {
                                  workout.increaseBreak();
                                  GetIt.instance
                                      .get<DatabaseService>()
                                      .saveWorkout(workout);
                                },
                                onSubtract: () {
                                  workout.decreaseBreak();
                                  GetIt.instance
                                      .get<DatabaseService>()
                                      .saveWorkout(workout);
                                },
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
                          exercises:
                              workout.exercises,
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
                Navigator.pushNamed(
                  context,
                  AddExercise.route,
                  arguments: AddExerciseArguments(workout)
                );
              },
            ),
          );
        },
      ),
    );
  }
}
