import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  String name;
  Duration duration;
  bool isBreak;
  bool hasBreakAfter;

  Exercise({this.id, this.name, this.duration, this.isBreak: false, this.hasBreakAfter});

  factory Exercise.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data;

    return Exercise(
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

