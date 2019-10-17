import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workout_timer/models/Workout.dart';

import 'DatabaseService.dart';

class WorkoutListProvider extends ChangeNotifier{
  List<Workout> _workouts = [];
  Workout _activeWorkout;
  bool isListening = false;

  UnmodifiableListView<Workout> get workouts => UnmodifiableListView(_workouts);

  Workout get activeWorkout{
    return _activeWorkout;
  }

  startListening(){
    if(!isListening){
      DatabaseService _db = GetIt.instance.get<DatabaseService>();
      _db.streamWorkouts().listen(_setWorkouts);
      isListening = true;
    }
  }

  _setWorkouts(List<Workout> workouts){
    for(Workout workout in _workouts) {
      workout.removeListener(workoutChanged);
    }
    _workouts = workouts;
    for(Workout workout in _workouts){
      workout.addListener(workoutChanged);
    }
    notifyListeners();
  }

  set activeWorkout(Workout workout){
    _activeWorkout = workout;
    notifyListeners();
  }

  void positionOf(Workout workout){
    _workouts.indexOf(workout);
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