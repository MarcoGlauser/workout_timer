import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';
import 'package:workout_timer/ui/screens/WorkoutScreen.dart';

import '../WorkoutActiveScreen.dart';

class WorkoutListItem extends StatelessWidget {
  final Workout workout;

  const WorkoutListItem({Key key, this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              workout.name,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${workout.exercises.length} Exercises "),
                  Text(
                      "${workout.totalDuration.inMinutes}:${(workout.totalDuration.inSeconds % 60).toString().padLeft(2, '0')} total time"),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonTheme.bar(
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.alarm),
                        const Text('Start Workout'),
                      ],
                    ),
                    onPressed: () {
                      Provider.of<WorkoutListProvider>(context).activeWorkout = workout;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutActiveScreen(),
                        ),
                      );
                    },
                  ),
                  FlatButton(
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.edit),
                        const Text('Edit'),
                      ],
                    ),
                    onPressed: () {
                      Provider.of<WorkoutListProvider>(context).activeWorkout = workout;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
