import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/provider/DatabaseService.dart';

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
            reorderExercise(oldIndex, newIndex);

          },
        ),
      );
    }
  }

  reorderExercise(int oldIndex, int newIndex){
    DatabaseService db = GetIt.instance.get<DatabaseService>();
    Exercise exercise = exercises[oldIndex];
    List<Exercise> exercisesToUpdate = updateIndices(newIndex, oldIndex);
    for(Exercise exercise in exercisesToUpdate){
      db.saveExercise(exercise);
    }
    exercise.index = newIndex;
    db.saveExercise(exercise);
  }

  updateIndices(int newIndex,int oldIndex){
    if(newIndex > oldIndex){
      return moveUp(oldIndex+1, newIndex);
    }
    else{
      return moveDown(newIndex, oldIndex-1);
    }
  }

  moveDown(int start, int end){
    List<Exercise> exercisesToUpdate = [];
    for(int i = start; i <= end; i++){
      exercises[i].index++;
      exercisesToUpdate.add(exercises[i]);
    }
    return exercisesToUpdate;
  }

  moveUp(int start, int end){
    List<Exercise> exercisesToUpdate = [];
    for(int i = start; i <= end; i++){
      exercises[i].index--;
      exercisesToUpdate.add(exercises[i]);
    }
    return exercisesToUpdate;
  }

  List<Widget> getChildrenTasks() {
    return exercises
        .map((exercise) => ExerciseListItem(key: UniqueKey(),exercise: exercise))
        .toList();
  }
}
