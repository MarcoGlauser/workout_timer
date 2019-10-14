
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:workout_timer/models/Exercise.dart';

class Workout extends ChangeNotifier{
  final List<Exercise> _exercises = [];
  String _name;
  int _repetitions;
  Duration _break;

  Workout({String name, int repetitions=1, Duration breakDuration = const Duration(seconds: 5)}){
    _name = name;
    _repetitions = repetitions;
    _break = breakDuration;
  }

  UnmodifiableListView<Exercise> get exercises => UnmodifiableListView(_exercises);

  String get name => _name;
  int get repetitions => _repetitions;
  Duration get breakDuration => _break;

  Duration get totalDuration {
    Duration total = Duration();
    for(Exercise exercise in _exercises){
      total += exercise.duration;
    }
    if(_exercises.length > 1){
      total += _break * (exercises.length -1);
    }
    return total * repetitions;
  }

  set name(String name){
    _name = name;
    notifyListeners();
  }

  set repetitions(int repetitions){
    _repetitions = repetitions;
    notifyListeners();
  }

  set breakDuration(Duration breakDuration){
    _break = breakDuration;
    notifyListeners();
  }

  void addExercise(Exercise exercise){
    _exercises.add(exercise);
    notifyListeners();
  }

  void reorderExercise(int oldIndex, int newIndex){
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Exercise exercise = _exercises.removeAt(oldIndex);
    _exercises.insert(newIndex, exercise);
    notifyListeners();
  }

  void deleteExercise(Exercise exercise){
    _exercises.remove(exercise);
    notifyListeners();
  }

}