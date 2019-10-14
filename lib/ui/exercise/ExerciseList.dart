import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/models/Workout.dart';

import 'ExerciseListItem.dart';

class ExerciseList extends StatelessWidget {
  final List<Exercise> exercises;

  const ExerciseList({@required this.exercises});


  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Center(
            child: Text('No Exercises yet', style:  Theme.of(context).textTheme.display1,),
          ),
        ),
      );
    } else {
      return Flexible(
        child: ReorderableListView(
          children: getChildrenTasks(),
          onReorder: (oldIndex, newIndex){
            Provider.of<Workout>(context).reorderExercise(oldIndex, newIndex);
          },
        ),
      );
    }
  }

  List<Widget> getChildrenTasks() {
    return exercises
        .map((exercise) => ExerciseListItem(key: UniqueKey(),exercise: exercise))
        .toList();
  }
}
