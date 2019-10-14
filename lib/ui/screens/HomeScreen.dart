import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/ui/screens/LoginScreen.dart';
import 'package:workout_timer/ui/screens/WorkoutListScreen.dart';



class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Consumer<FirebaseUser>(
      builder: (context, user, child) {
        if(user == null){
          FirebaseAuth.instance.signInAnonymously();
          return LoginScreen();
        }
        else{
          return WorkoutListScreen();
        }
      },
    );
  }
}
