import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/DatabaseService.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';

class StreamHandler{
  final WorkoutListProvider workoutListProvider;
  Map<String, StreamSubscription> streamSubscriptions = {};
  bool isListening = false;
  StreamHandler(this.workoutListProvider);

  listenForWorkoutChanges(){
    if(!isListening) {
      DatabaseService db = GetIt.instance.get<DatabaseService>();
      Stream<DocumentChange> workoutChanges = db.streamWorkoutChanges();
      workoutChanges.listen(handleWorkoutChange);
      isListening = true;
    }
  }

  listenForExerciseChanges(Workout workout){
    if(!streamSubscriptions.containsKey(workout.id)) {
      DatabaseService db = GetIt.instance.get<DatabaseService>();
      Stream<DocumentChange> exerciseChanges = db.streamExerciseChanges(workout);
      StreamSubscription subscription = exerciseChanges.listen((DocumentChange documentchange) => handleExerciseChange(workout, documentchange));
      streamSubscriptions[workout.id] = subscription;
    }
  }

  cancelExerciseSubscription(Workout workout){
    streamSubscriptions[workout.id].cancel();
  }

  void handleWorkoutChange(DocumentChange documentChange){
    Workout workout = Workout.fromFirestore(documentChange.document);
    switch(documentChange.type) {
      case DocumentChangeType.added:
        workoutListProvider.addWorkout(workout,index: documentChange.newIndex);
        listenForExerciseChanges(workout);
        break;
      case DocumentChangeType.modified:
        if(documentChange.oldIndex == documentChange.newIndex){
          workoutListProvider.reorderWorkout(documentChange.oldIndex, documentChange.newIndex);
        }
        workoutListProvider.updateWorkout(workout);
        break;
      case DocumentChangeType.removed:
        workoutListProvider.deleteWorkout(workout);
        cancelExerciseSubscription(workout);
        break;
    }
  }

  void handleExerciseChange(Workout workout, DocumentChange documentChange){
    Exercise exercise = Exercise.fromFirestore(workout, documentChange.document);
    switch(documentChange.type){
      case DocumentChangeType.added:
        workout.addExercise(exercise, index: documentChange.newIndex);
        break;
      case DocumentChangeType.modified:
        if(documentChange.oldIndex == documentChange.newIndex){
          workout.reorderExercise(documentChange.oldIndex, documentChange.newIndex);
        }
        break;
      case DocumentChangeType.removed:
        workout.deleteExercise(exercise);
        break;
    }
  }
}