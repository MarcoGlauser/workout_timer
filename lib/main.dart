import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/provider/CountdownProvider.dart';
import 'package:workout_timer/provider/DatabaseService.dart';
import 'package:workout_timer/provider/StreamHandler.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';
import 'package:workout_timer/router.dart';
import 'package:workout_timer/theme.dart';

void main() {
  GetIt.instance
      .registerLazySingleton<DatabaseService>(() => DatabaseService());
  runApp(WorkoutTimer());
}

class WorkoutTimer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ));

    GetIt.instance.get<DatabaseService>();

    WorkoutListProvider workoutListProvider = WorkoutListProvider();
    StreamHandler streamHandler = StreamHandler(workoutListProvider);

    return MultiProvider(
      providers: [
        Provider.value(value: streamHandler),
        ChangeNotifierProvider.value(value: workoutListProvider),
        ChangeNotifierProvider(create: (_) => CountdownProvider()),
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
      ],
      child: MaterialApp(
        title: 'Workout Timer',
        theme: defaultTheme,
        darkTheme: darkTheme,
        //home: CountdownTimer(title: 'Pushups', duration: Duration(seconds: 30),),

        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
