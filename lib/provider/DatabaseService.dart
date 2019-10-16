import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/models/Workout.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  FirebaseUser _user;

  DatabaseService(this._user){
    _db.settings(persistenceEnabled: true);
  }

  Stream<List<Workout>> streamWorkouts() {
    var ref = _db.collection('userData').document(_user.uid).collection('workouts');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Workout.fromFirestore(doc)).toList());
  }

  Stream<List<Exercise>> streamExercises(Workout workout){
    var ref = _db.collection('userData').document(_user.uid).collection('workouts').document(workout.id).collection('exercises');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Exercise.fromFirestore(doc)).toList());
  }
  Future<void> saveWorkout(Workout workout){
    return _db.collection('userData').document(_user.uid).collection('workouts').document(workout.id).setData(workout.toMap());
  }

  Future<void> saveExercise(Workout workout, Exercise exercise){
    return _db.collection('userData').document(_user.uid).collection('workouts').document(workout.id).collection('exercises').document(exercise.id).setData(exercise.toMap());
  }
}