import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:workout_timer/models/Workout.dart';

class WorkoutListProvider extends ChangeNotifier{
  final List<Workout> _workouts = [];
  Workout _activeWorkout;

  UnmodifiableListView<Workout> get workouts => UnmodifiableListView(_workouts);

  Workout get activeWorkout{
    return _activeWorkout;
  }

  set activeWorkout(Workout workout){
    _activeWorkout = workout;
    notifyListeners();
  }

  void addWorkout(Workout workout){
    _workouts.add(workout);
    workout.addListener(workoutChanged);
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

  void workoutChanged(){
    notifyListeners();
  }
}