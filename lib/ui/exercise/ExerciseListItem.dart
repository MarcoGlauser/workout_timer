import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;

  const ExerciseListItem({Key key, this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exercise.name),
      subtitle: Text(exercise.duration.inSeconds.toString() + " Seconds"),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
          color: Theme.of(context).textTheme.body1.color,
        ),
        onPressed: () {
          Provider.of<WorkoutListProvider>(context, listen: false).activeWorkout.deleteExercise(exercise);
        },
      ),
    );
  }
}
