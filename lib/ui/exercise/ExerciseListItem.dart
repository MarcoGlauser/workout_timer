import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/provider/DatabaseService.dart';
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditExercise(
                    exercise: exercise,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).textTheme.body1.color,
            ),
            onPressed: () {
              GetIt.instance.get<DatabaseService>().deleteExercise(exercise);
            },
          ),
        ],
      ),
    );
  }
}
