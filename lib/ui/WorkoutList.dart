

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';
import 'package:workout_timer/ui/WorkoutListItem.dart';

class WorkoutList extends StatelessWidget {
  final List<Workout> workouts;

  const WorkoutList({@required this.workouts});


  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Center(
            child: Text('No Workouts yet', style:  Theme.of(context).textTheme.display1,),
          ),
        ),
      );
    } else {
      return Flexible(
        child: ReorderableListView(
          children: getChildrenTasks(),
          onReorder: (oldIndex, newIndex){
            Provider.of<WorkoutListProvider>(context).reorderWorkout(oldIndex, newIndex);
          },
        ),
      );
    }
  }

  List<Widget> getChildrenTasks() {
    return workouts
        .map((workout) => WorkoutListItem(key: UniqueKey(),workout: workout))
        .toList();
  }
}
