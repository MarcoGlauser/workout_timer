import 'package:cloud_firestore/cloud_firestore.dart';

import 'Workout.dart';

class Exercise {
  final Workout parent;
  final String id;
  String name;
  Duration duration;
  bool isBreak;
  bool hasBreakAfter;

  Exercise(this.parent, {this.id, this.name, this.duration, this.isBreak: false, this.hasBreakAfter});

  factory Exercise.fromFirestore(Workout parent, DocumentSnapshot doc){
    Map data = doc.data;

    return Exercise(
      parent,
      id: doc.documentID,
      name: data['name'] ?? '',
      duration: Duration(seconds: data['duration'] ?? 0),
      isBreak: false,
      hasBreakAfter: true
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'duration': duration.inSeconds
    };
  }

}

