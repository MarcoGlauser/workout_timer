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

  void positionOf(Workout workout){
    _workouts.indexOf(workout);
  }

  void addWorkout(Workout workout, {int index: 0}){
    _workouts.insert(index, workout);
    workout.addListener(workoutChanged);
    notifyListeners();
  }

  void updateWorkout(Workout workout){
    int updateIndex = _workouts.indexWhere((Workout innerWorkout) => workout.id == innerWorkout.id);
    _workouts.removeAt(updateIndex);
    addWorkout(workout, index: updateIndex);
    if(_activeWorkout!= null && _activeWorkout.id == workout.id){
      _activeWorkout = workout;
    }
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
    int deleteIndex = _workouts.indexWhere((Workout innerWorkout) => workout.id == innerWorkout.id);
    _workouts.removeAt(deleteIndex);
    notifyListeners();
  }

  void workoutChanged(){
    notifyListeners();
  }
}