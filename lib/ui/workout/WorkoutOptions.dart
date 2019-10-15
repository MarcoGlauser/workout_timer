import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';

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
            print(Navigator.pop(context));
            Provider.of<WorkoutListProvider>(context).deleteWorkout(workout);
        }
      },
    );
  }
}