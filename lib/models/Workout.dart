
import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_timer/models/Exercise.dart';

class Workout extends ChangeNotifier{

  final String id;
  final List<Exercise> _exercises = [];
  String _name;
  int _repetitions;
  Duration _break;

  Workout({this.id, String name, int repetitions=1, Duration breakDuration = const Duration(seconds: 5)}){
    _name = name;
    _repetitions = repetitions;
    _break = breakDuration;
  }

  factory Workout.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data;
    return Workout(
      id: doc.documentID,
      name: data['name'] ?? '',
      repetitions: data['repetitions'] ?? 1,
      breakDuration: Duration(seconds: data['break'] ?? 0)
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'repetitions': repetitions,
      'break': breakDuration.inSeconds
    };
  }

  UnmodifiableListView<Exercise> get exercises => UnmodifiableListView(_exercises);

  String get name => _name;
  int get repetitions => _repetitions;
  Duration get breakDuration => _break;

  Duration get totalDuration {
    Duration total = Duration();
    for(Exercise exercise in _exercises){
      total += exercise.duration;
      total += _break;
    }
    total *= repetitions;
    if(_exercises. length > 0 && repetitions > 1){
      total -= _break;
    }
    return total;
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

  void increaseRepetitions(){
    _repetitions += 1;
    notifyListeners();
  }

  void decreaseRepetitions(){
    _repetitions = max(1, _repetitions-1);
    notifyListeners();
  }

  void increaseBreak(){
    _break += Duration(seconds: 1);
    notifyListeners();
  }

  void decreaseBreak(){
    Duration oneSecond = Duration(seconds: 1);
    if((_break - oneSecond).inSeconds >= 0){
      _break = (_break - oneSecond);
      notifyListeners();
    }
  }

  void addExercise(Exercise exercise, {int index: 0}){
    _exercises.insert(index, exercise);
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
    int deleteIndex = _exercises.indexWhere((Exercise innerExercise) => exercise.id == innerExercise.id);
    _exercises.removeAt(deleteIndex);
    notifyListeners();
  }


  List<Exercise> updateExerciseIndices(Workout workout){
    List<Exercise> updatedExercises = [];
    for(int i = 0; i < _exercises.length; i++){
      Exercise exercise = _exercises[i];
      if(exercise.index != i){
        exercise.index = i;
        updatedExercises.add(exercise);
      }
    }
    return updatedExercises;
  }

}