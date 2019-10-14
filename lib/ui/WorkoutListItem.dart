import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/CountdownProvider.dart';
import 'package:workout_timer/ui/WorkoutScreen.dart';

import 'WorkoutActiveScreen.dart';

class WorkoutListItem extends StatelessWidget {
  final Workout workout;

  const WorkoutListItem({Key key, this.workout}) : super(key: key);

  void fillCountdownProvider(context) {
    Provider.of<CountdownProvider>(context).exercises = workout.exercises;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              workout.name,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Text("${workout.exercises.length} Exercises "),
          Text(
              "${workout.totalDuration.inMinutes}:${(workout.totalDuration.inSeconds % 60).toString().padLeft(2, '0')} total time"),
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
                      fillCountdownProvider(context);
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: workout,
                            child: Consumer<Workout>(
                              builder: (context, workout, child) {
                                return WorkoutScreen(workout: workout);
                              },
                            ),
                          ),
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
