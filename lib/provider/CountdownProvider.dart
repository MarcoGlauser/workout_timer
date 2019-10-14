
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:workout_timer/models/Exercise.dart';

class CountdownProvider extends ChangeNotifier{
  Queue<Exercise> _queue = Queue();
  final BuildContext context;

  CountdownProvider(this.context);

  Exercise get exercise => _queue.first;
  bool get isFinished => _queue.isEmpty;

  set exercises(Iterable<Exercise> iterable) {
    _queue.clear();
    for (Exercise exercise in iterable){
      if(exercise == iterable.last){
        _queue.add(exercise);
      }
      else{
        _queue.add(exercise);
        _queue.add(Exercise(name: 'Break', duration: Duration(seconds: 20)));
      }
    }
  }

  void exerciseFinished(){
    if(_queue.isNotEmpty) {
      _queue.removeFirst();
      notifyListeners();
    }
  }
}