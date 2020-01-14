import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/provider/StreamHandler.dart';

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
            if(newIndex > oldIndex){
              newIndex -= 1;
            }
            Exercise exercise = exercises[oldIndex];
            Provider.of<StreamHandler>(context).reorderExercise(exercise, oldIndex, newIndex);
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
