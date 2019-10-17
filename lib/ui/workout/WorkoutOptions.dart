import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/DatabaseService.dart';

class WorkoutOptions extends StatelessWidget{

  final Workout workout;

  const WorkoutOptions({Key key, this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      offset: Offset(0, 50),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.delete),
              ),
              Text("Delete Workout"),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch(value){
          case 1:
            Navigator.pop(context);
            GetIt.instance.get<DatabaseService>().deleteWorkout(workout);
        }
      },
    );
  }
}