import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/provider/CountdownProvider.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';
import 'package:workout_timer/theme.dart';
import 'package:workout_timer/ui/screens/HomeScreen.dart';

import 'models/Workout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ));

    if (FirebaseAuth.instance.currentUser() == null) {
      FirebaseAuth.instance.signInAnonymously();
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => Workout(),
        ),
        ChangeNotifierProvider(
          builder: (_) => WorkoutListProvider(),
        ),
        ChangeNotifierProvider(
          builder: (context) => CountdownProvider(context),
        ),
        StreamProvider<FirebaseUser>.value(value: FirebaseAuth.instance.onAuthStateChanged),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: defaultTheme,
          darkTheme: darkTheme,
          //home: CountdownTimer(title: 'Pushups', duration: Duration(seconds: 30),),
          home: HomeScreen()),
    );
  }
}

