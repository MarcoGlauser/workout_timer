import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/models/Workout.dart';

class CountdownProvider extends ChangeNotifier {
  Queue<Exercise> _queue = Queue();

  CountdownProvider();

  Exercise get exercise => _queue.first;

  bool get isFinished => _queue.isEmpty;

  set workout(Workout workout) {
    _queue.clear();
    if (workout != null) {
      for (Exercise exercise in workout.exercises) {
        if (exercise == workout.exercises.last) {
          _queue.add(exercise);
        } else {
          _queue.add(exercise);
          if(workout.breakDuration.inSeconds > 0) {
            _queue.add(
                Exercise(name: 'Break', duration: workout.breakDuration));
          }
        }
      }
    }
  }

  void exerciseFinished() {
    if (_queue.isNotEmpty) {
      _queue.removeFirst();
      notifyListeners();
    }
  }
}
