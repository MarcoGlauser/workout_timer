import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/DatabaseService.dart';
import 'package:workout_timer/ui/screens/HomeScreen.dart';


class AddExercise extends StatefulWidget {
  final Workout workout;

  const AddExercise({Key key, this.workout}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _AddExerciseState(workout);
}


class _AddExerciseState extends State<AddExercise>{
  final Workout workout;
  final _formKey = GlobalKey<FormState>();
  Exercise _exercise;

  _AddExerciseState(this.workout);

  @override
  void initState() {
    super.initState();
    _exercise = Exercise(workout, index: workout.exercises.length);
  }

  @override
  Widget build(BuildContext context) {
    return Login(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Exercise'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    autofocus: true,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Exercise Name'
                    ),
                    onSaved: (val) {
                      setState(() => _exercise.name = val);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a number';
                      }
                      return null;
                    },
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Duration in seconds'
                    ),
                    onSaved: (val) => setState(() => _exercise.duration = Duration(seconds: int.parse(val))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        //workout.addExercise(_exercise);
                        DatabaseService db = GetIt.instance.get<DatabaseService>();
                        db.saveExercise(_exercise);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}