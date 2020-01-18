import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/services/WorkoutListProvider.dart';
import 'package:workout_timer/ui/login/LoginRequired.dart';
import 'WorkoutListContent.dart';


class WorkoutListScreen extends StatelessWidget {
  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return LoginRequired(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Workouts'),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Consumer<WorkoutListProvider>(
                builder: (context, workoutList, child) {
                  return WorkoutList(
                    workouts: workoutList.workouts,
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/workout/add'
            );
          },
        ),
      ),
    );
  }
}
