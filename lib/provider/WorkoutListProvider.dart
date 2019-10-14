import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:workout_timer/models/Workout.dart';

class WorkoutListProvider extends ChangeNotifier{
  final List<Workout> _workouts = [];

  UnmodifiableListView<Workout> get workouts => UnmodifiableListView(_workouts);
  List<Workout> get workoutsIterable => _workouts;

  void addWorkout(Workout workout){
    _workouts.add(workout);
    notifyListeners();
  }

  void reorderWorkout(int oldIndex, int newIndex){
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Workout workout = _workouts.removeAt(oldIndex);
    _workouts.insert(newIndex, workout);
    notifyListeners();
  }

  void deleteWorkout(Workout workout){
    _workouts.remove(workout);
    notifyListeners();
  }
}