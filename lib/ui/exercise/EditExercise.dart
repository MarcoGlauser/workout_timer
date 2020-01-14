import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:workout_timer/models/Exercise.dart';
import 'package:workout_timer/provider/DatabaseService.dart';
import 'package:workout_timer/ui/screens/LoginRequired.dart';


class EditExercise extends StatefulWidget {
  final Exercise exercise;

  const EditExercise({Key key, this.exercise}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditExerciseState(exercise);
}


class _EditExerciseState extends State<EditExercise>{
  final _formKey = GlobalKey<FormState>();
  final Exercise exercise;

  _EditExerciseState(this.exercise);

  @override
  Widget build(BuildContext context) {
    return LoginRequired(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Exercise'),
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
                    initialValue: exercise.name,
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
                      setState(() => exercise.name = val);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextFormField(
                    initialValue: exercise.duration.inSeconds.toString(),
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
                    onSaved: (val) => setState(() => exercise.duration = Duration(seconds: int.parse(val))),
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
                        db.saveExercise(exercise);
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