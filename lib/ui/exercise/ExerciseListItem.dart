import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/services/StreamHandler.dart';
import 'package:workout_timer/ui/exercise/EditExercise.dart';

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;

  const ExerciseListItem({Key key, this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exercise.name),
      subtitle: Text(exercise.duration.inSeconds.toString() + " Seconds"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).textTheme.body1.color,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                EditExercise.route,
                arguments: EditExerciseArguments(exercise)
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).textTheme.body1.color,
            ),
            onPressed: () {
              Provider.of<StreamHandler>(context, listen: false).deleteExercise(exercise);
            },
          ),
        ],
      ),
    );
  }
}
