import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workout_timer/ui/countdown/WorkoutActiveScreen.dart';
import 'package:workout_timer/ui/exercise/AddExercise.dart';
import 'package:workout_timer/ui/exercise/EditExercise.dart';
import 'package:workout_timer/ui/workout/WorkoutList.dart';
import 'package:workout_timer/ui/workout/EditWorkout.dart';
import 'package:workout_timer/ui/workout/AddWorkout.dart';


class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name){
      case WorkoutListScreen.route:
        return MaterialPageRoute(settings: settings,builder: (context) => WorkoutListScreen());
      case AddWorkoutScreen.route:
        return MaterialPageRoute(settings: settings,builder: (context) => AddWorkoutScreen());
      case WorkoutScreen.route:
        return MaterialPageRoute(settings: settings, builder: (context) => WorkoutScreen());
      case WorkoutActiveScreen.route:
        return MaterialPageRoute(settings: settings, builder: (context) => WorkoutActiveScreen());
      case AddExercise.route:
        final AddExerciseArguments addExerciseArguments = settings.arguments;
        return MaterialPageRoute(settings: settings, builder: (context) =>
            AddExercise(workout: addExerciseArguments.workout));
      case EditExercise.route:
        final EditExerciseArguments editExerciseArguments = settings.arguments;
        return MaterialPageRoute(settings: settings, builder: (context) =>
            EditExercise(exercise: editExerciseArguments.exercise));
    }
  }
}