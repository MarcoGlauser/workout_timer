
import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/provider/DatabaseService.dart';

class Workout extends ChangeNotifier{

  final String id;
  List<Exercise> _exercises = [];
  String _name;
  int _repetitions;
  Duration _break;

  Workout({this.id, String name, int repetitions=1, Duration breakDuration = const Duration(seconds: 5)}){
    _name = name;
    _repetitions = repetitions;
    _break = breakDuration;
    _startListening();
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

  _startListening() {
    DatabaseService _db = GetIt.instance.get<DatabaseService>();
    _db.streamExercises(this).listen(_setExercises);
  }

  _setExercises(List<Exercise> exercises){
    _exercises = exercises;
    notifyListeners();
  }

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
    if(repetitions >= 1){
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
  }

  void decreaseRepetitions(){
    _repetitions = max(1, _repetitions-1);
  }

  void increaseBreak(){
    _break += Duration(seconds: 1);
  }

  void decreaseBreak(){
    Duration oneSecond = Duration(seconds: 1);
    if((_break - oneSecond).inSeconds >= 0){
      _break = (_break - oneSecond);
    }
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