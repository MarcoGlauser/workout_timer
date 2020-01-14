import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/DatabaseService.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';

class StreamHandler{
  final WorkoutListProvider workoutListProvider;
  StreamSubscription workoutSubscription;
  DatabaseService db;
  Map<String, StreamSubscription> streamSubscriptions = {};
  bool isListening = false;
  StreamHandler(this.workoutListProvider){
    db = GetIt.instance.get<DatabaseService>();
    FirebaseAuth.instance.onAuthStateChanged.listen((FirebaseUser user){
      cancelWorkoutSubscription();
      listenForWorkoutChanges();
    });
  }


  listenForWorkoutChanges(){
    if(!isListening) {
      Stream<DocumentChange> workoutChanges = db.streamWorkoutChanges();
      workoutSubscription = workoutChanges.listen(handleWorkoutChange);
      isListening = true;
    }
  }

  cancelWorkoutSubscription(){
    if(isListening){
      workoutSubscription.cancel();
      isListening = false;
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
    streamSubscriptions.remove(workout.id);
  }

  addExercisesSnapshotToWorkout(Workout workout) async{
    DatabaseService db = GetIt.instance.get<DatabaseService>();
    QuerySnapshot querySnapshot = await db.exercisesSnapshot(workout);
    for(DocumentSnapshot documentSnapshot in querySnapshot.documents){
      Exercise exercise = Exercise.fromFirestore(workout, documentSnapshot);
      workout.addExercise(exercise);
    }
  }

  void handleWorkoutChange(DocumentChange documentChange) async{
    Workout workout = Workout.fromFirestore(documentChange.document);
    await addExercisesSnapshotToWorkout(workout);
    switch(documentChange.type) {
      case DocumentChangeType.added:
        workoutListProvider.addWorkout(workout,index: documentChange.newIndex);
        listenForExerciseChanges(workout);
        break;
      case DocumentChangeType.modified:
        cancelExerciseSubscription(workout);
        listenForExerciseChanges(workout);
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
        workout.addExercise(exercise);
        break;
      case DocumentChangeType.modified:
        workout.updateExercise(exercise);
        break;
      case DocumentChangeType.removed:
        workout.deleteExercise(exercise);
        break;
    }
  }

  void deleteExercise(Exercise exercise){
    DatabaseService db = GetIt.instance.get<DatabaseService>();
    List<Exercise> exercises = exercise.parent.exercises;
    List<Exercise> exercisesToUpdate = moveUp(exercises, exercise.index, exercises.length-1);
    for(Exercise exercise in exercisesToUpdate){
      db.saveExercise(exercise);
    }
    db.deleteExercise(exercise);
  }

  reorderExercise(Exercise exercise, int oldIndex, int newIndex){
    DatabaseService db = GetIt.instance.get<DatabaseService>();
    List<Exercise> exercisesToUpdate = updateIndices(exercise.parent.exercises, newIndex, oldIndex);
    for(Exercise exercise in exercisesToUpdate){
      db.saveExercise(exercise);
    }
    exercise.index = newIndex;
    db.saveExercise(exercise);
  }

  updateIndices(List<Exercise> exercises, int newIndex,int oldIndex){
    if(newIndex > oldIndex){
      return moveUp(exercises, oldIndex+1, newIndex);
    }
    else{
      return moveDown(exercises, newIndex, oldIndex-1);
    }
  }

  moveDown(List<Exercise> exercises, int start, int end){
    List<Exercise> exercisesToUpdate = [];
    for(int i = start; i <= end; i++){
      exercises[i].index++;
      exercisesToUpdate.add(exercises[i]);
    }
    return exercisesToUpdate;
  }

  moveUp(List<Exercise> exercises,int start, int end){
    List<Exercise> exercisesToUpdate = [];
    for(int i = start; i <= end; i++){
      exercises[i].index--;
      exercisesToUpdate.add(exercises[i]);
    }
    return exercisesToUpdate;
  }
}