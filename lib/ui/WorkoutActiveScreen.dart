import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/CountdownProvider.dart';

import 'CountdownTimer.dart';
import 'WorkoutFinished.dart';

class WorkoutActiveScreenArguments{
  final Workout workout;

  WorkoutActiveScreenArguments(this.workout);
}

class WorkoutActiveScreen extends StatefulWidget {
  static const route = '/workout/start';

  @override
  _WorkoutActiveScreenState createState() => _WorkoutActiveScreenState();
}

class _WorkoutActiveScreenState extends State<WorkoutActiveScreen>{

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutActiveScreenArguments screenArguments = ModalRoute.of(context).settings.arguments;
    Provider.of<CountdownProvider>(context, listen: false).workout = screenArguments.workout;

    return Consumer<CountdownProvider>(
        builder: (context, countdownProvider, child) {
      if (countdownProvider.isFinished) {
        Wakelock.disable();
        return WorkoutFinished();
      } else {
        return CountdownTimer(
            key: UniqueKey(),
            title: countdownProvider.exercise.name,
            duration: countdownProvider.exercise.duration,
            next: countdownProvider.nextExercise.name,
        );
      }
    });
  }

  void dispose() {
    super.dispose();
    Wakelock.disable();
  }
}
