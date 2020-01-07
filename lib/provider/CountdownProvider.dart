import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/models/Workout.dart';

class CountdownProvider extends ChangeNotifier {
  Queue<Exercise> _queue = Queue();

  CountdownProvider();

  Exercise get exercise => _queue.first;
  Exercise get nextExercise {
    if(_queue.length != 1){
      return _queue.elementAt(1);
    }
    else {
      return null;
    }
  }

  bool get isFinished => _queue.isEmpty;

  set workout(Workout workout) {
    _queue.clear();
    if (workout != null) {
      _addExercisesFromWorkout(workout);
    }
  }

  _addExercisesFromWorkout(Workout workout){
    for(int i in Iterable.generate(workout.repetitions)) {
      for (Exercise exercise in workout.exercises) {
        if (exercise == workout.exercises.last) {
          _addExercise(exercise);
        } else {
          _addExercise(exercise);
          _addBreak(workout.breakDuration);
        }
      }
      if(i != workout.repetitions-1){
        _addBreak(workout.breakDuration);
      }
    }
  }

  void _addExercise(Exercise exercise,{Duration breakDuration}){
    _queue.add(exercise);
  }

  void _addBreak(Duration breakDuration){
    if(breakDuration.inSeconds > 0){
      _queue.add( Exercise(null, name: 'Break', duration: breakDuration));
    }
  }

  void exerciseFinished() {
    if (_queue.isNotEmpty) {
      _queue.removeFirst();
      notifyListeners();
    }
  }
}
