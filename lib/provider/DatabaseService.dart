import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/models/Workout.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  FirebaseUser _user;

  StreamTransformer<QuerySnapshot, DocumentChange> snapshotToDocumentChangeTransformer = StreamTransformer<QuerySnapshot, DocumentChange>.fromHandlers(
    handleData: (QuerySnapshot snapshot, EventSink sink) {
      for (DocumentChange documentChange in snapshot.documentChanges) {
        sink.add(documentChange);
      }
    },
  );

  DatabaseService(this._user) {
    _db.settings(persistenceEnabled: true);
  }

  Stream<DocumentChange> streamWorkoutChanges() {
    var ref =_db
        .collection('userData')
        .document(_user.uid)
        .collection('workouts');
    return ref.snapshots().transform(snapshotToDocumentChangeTransformer);
  }

  Stream<DocumentChange> streamExerciseChanges(Workout workout) {
    var ref =_db
        .collection('userData')
        .document(_user.uid)
        .collection('workouts')
        .document(workout.id)
        .collection('exercises');

    return ref.snapshots().transform(snapshotToDocumentChangeTransformer);
  }

  Future<void> saveWorkout(Workout workout) {
    return _db
        .collection('userData')
        .document(_user.uid)
        .collection('workouts')
        .document(workout.id)
        .setData(workout.toMap());
  }

  Future<void> deleteWorkout(Workout workout) {
    return _db
        .collection('userData')
        .document(_user.uid)
        .collection('workouts')
        .document(workout.id)
        .delete();
  }

  Future<void> saveExercise(Exercise exercise) {
    return _db
        .collection('userData')
        .document(_user.uid)
        .collection('workouts')
        .document(exercise.parent.id)
        .collection('exercises')
        .document(exercise.id)
        .setData(exercise.toMap());
  }

  Future<void> deleteExercise(Exercise exercise) {
    return _db
        .collection('userData')
        .document(_user.uid)
        .collection('workouts')
        .document(exercise.parent.id)
        .collection('exercises')
        .document(exercise.id)
        .delete();
  }
}
