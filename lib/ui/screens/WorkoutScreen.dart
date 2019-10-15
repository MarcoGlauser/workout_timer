import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';

import '../AddSubtract.dart';
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
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: AddSubtract(
                                child: Text(
                                    "${workoutListProvider.activeWorkout.repetitions} Repetition",
                                    style: Theme.of(context).textTheme.title),
                                onAdd: (){
                                  workoutListProvider.activeWorkout.increaseRepetitions();
                                },
                                onSubtract: (){
                                  workoutListProvider.activeWorkout.decreaseRepetitions();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: AddSubtract(
                                child:
                                  Text(
                                      "${workoutListProvider.activeWorkout.breakDuration.inMinutes.toString().padLeft(2,'0')}:${(workoutListProvider.activeWorkout.breakDuration.inSeconds%60).toString().padLeft(2,'0')}  Break",
                                      style:
                                          Theme.of(context).textTheme.title),
                                onAdd: (){
                                  workoutListProvider.activeWorkout.increaseBreak();
                                },
                                onSubtract: (){
                                  workoutListProvider.activeWorkout.decreaseBreak();
                                },
                              ),
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
                  builder: (context) =>
                      AddExercise(workout: workoutListProvider.activeWorkout),
                ),
              );
            },
          ),
        );
      },
    );
  }
}